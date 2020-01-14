#include <stdio.h>
#include <stdlib.h> /* rand() */
#include <limits.h>
#include <pthread.h> /* for pthread_spinlock_t */

#include "../common/alloc.h"
#include "ll.h"

typedef struct ll_node {
    int key;
    struct ll_node *next;
    pthread_spinlock_t *lock;
} ll_node_t;

struct linked_list {
	ll_node_t *head;
	/* other fields here? */
};

/**
 * Create a new linked list node.
 **/
static ll_node_t *ll_node_new(int key)
{
    ll_node_t *ret;

    XMALLOC(ret, 1);
    ret->key = key;
    ret->next = NULL;
    XMALLOC(ret->lock, 1);  //Clang-Tidy gives warning about this
    pthread_spin_init(ret->lock, PTHREAD_PROCESS_PRIVATE);
    /* Other initializations here? */

    return ret;
}


/**
 * Free a linked list node.
 **/
static void ll_node_free(ll_node_t *ll_node)
{
    // TODO: Consider if this should be used at all on optimistc locking
    pthread_spin_destroy(ll_node->lock);
    XFREE(ll_node->lock);
    XFREE(ll_node);
}


/**
 * Create a new empty linked list.
 **/
ll_t *ll_new()
{
    ll_t *ret;

    XMALLOC(ret, 1);
    ret->head = ll_node_new(-1);
    ret->head->next = ll_node_new(INT_MAX);
    ret->head->next->next = NULL;

    return ret;
}

/**
 * Free a linked list and all its contained nodes.
 **/
void ll_free(ll_t *ll)
{
	ll_node_t *next, *curr = ll->head;
	while (curr) {
		next = curr->next;
		ll_node_free(curr);
		curr = next;
	}
	XFREE(ll);
}

// Copied from lecture slides
static int ll_validate(ll_t *ll, ll_node_t * pred, ll_node_t *curr)
{
    ll_node_t *node = ll->head;
    while(node->key <= pred->key)
    {
        if(node == pred)
        {
            return pred->next == curr;
        }
        node = node->next;
    }

    return 0;
}

// This is the same as in ll_fgl.c
int ll_contains(ll_t *ll, int key)
{
    ll_node_t *curr;
    pthread_spin_lock(ll->head->lock);
    curr = ll->head;

    while(curr->key < key)
    {
        pthread_spin_unlock(curr->lock);
        curr = curr->next;
        pthread_spin_lock(curr->lock);
    }

    if(curr->key == key)
    {
        pthread_spin_unlock(curr->lock);
        return  1;
    }
    else
    {
        pthread_spin_unlock(curr->lock);
        return 0;
    }
}

int ll_add(ll_t *ll, int key)
{
    while(1)
    {
        ll_node_t *pred = ll->head;
        ll_node_t *succ = pred->next;
        while(succ->key < key)
        {
            pred = succ;
            succ = succ->next;
        }
        pthread_spin_lock(pred->lock);
        pthread_spin_lock(succ->lock);

        if(ll_validate(ll, pred, succ))
        {
            ll_node_t  *new_node = ll_node_new(key);
            pred->next = new_node;
            new_node->next = succ;

            pthread_spin_unlock(succ->lock);
            pthread_spin_unlock(pred->lock);
            return 1;
        }
    }
}

int ll_remove(ll_t *ll, int key)
{
    while(1)
    {
        ll_node_t *pred = ll->head;
        ll_node_t *curr = pred->next;
        while(curr->key <= key)
        {
            if(curr->key == key) break;
            pred = curr;
            curr = curr->next;
        }
        pthread_spin_lock(pred->lock);
        pthread_spin_lock(curr->lock);

        if(ll_validate(ll, pred, curr))
        {
            if(curr->key == key)
            {
                pred->next = curr->next;
                pthread_spin_unlock(pred->lock);
                pthread_spin_unlock(curr->lock);
                return 1;
            }
            else
            {
                pthread_spin_unlock(pred->lock);
                pthread_spin_unlock(curr->lock);
                return 0;
            }
        }
    }
}

/**
 * Print a linked list.
 **/
void ll_print(ll_t *ll)
{
	ll_node_t *curr = ll->head;
	printf("LIST [");
	while (curr) {
		if (curr->key == INT_MAX)
			printf(" -> MAX");
		else
			printf(" -> %d", curr->key);
		curr = curr->next;
	}
	printf(" ]\n");
}
