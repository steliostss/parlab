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

/* Works exactly like ll_remove(), locking the candidate node.
 * I don't think any other node needs to be locked since in order
 * for the ->next field to change, ll_add() and ll_remove() would
 * need to lock the curr node first.
*/
int ll_contains(ll_t *ll, int key)
{
    ll_node_t *curr;
    pthread_spin_lock(ll->head->lock);
    curr = ll->head;
    ll_node_t *succ;
    pthread_spin_lock(curr->next->lock);
    succ = curr->next;

    while(curr->key < key && succ->key != INT_MAX)
    {
        pthread_spin_unlock(curr->lock);
        curr = succ;
        succ = succ->next;
        pthread_spin_lock(succ->lock);
    }
    int temp_key = curr->key;
    pthread_spin_unlock(curr->lock);
    pthread_spin_unlock(succ->lock);
    return (temp_key == key);
}

// Works exactly like ll_remove(), but locking the candidate predecessor and successor
// of the new node.
int ll_add(ll_t *ll, int key)
{
    ll_node_t *pred, *succ;
    pthread_spin_lock(ll->head->lock);
    pred = ll->head;
    succ = pred->next;
    pthread_spin_lock(succ->lock);

    while(succ->key < key)
    {
        pthread_spin_unlock(pred->lock);
        pred = succ;
        succ = succ->next;
        pthread_spin_lock(succ->lock);
    }
    if (succ->key != key) {
        // Create and insert new ll_node
        ll_node_t *new_node = ll_node_new(key);
        pred->next = new_node;
        new_node->next = succ;
        pthread_spin_unlock(succ->lock);
        pthread_spin_unlock(pred->lock);
        return 1;
    }
    else {
        pthread_spin_unlock(succ->lock);
        pthread_spin_unlock(pred->lock);
        return 0;
    }
}

// Copied from lecture slides
int ll_remove(ll_t *ll, int key)
{
    ll_node_t *pred, *curr;
    pthread_spin_lock(ll->head->lock);
    pred = ll->head;
    curr = pred->next;
    pthread_spin_lock(curr->lock);

    while(curr->key < key)
    {
        pthread_spin_unlock(pred->lock);
        pred = curr;
        pthread_spin_lock(curr->next->lock);
        curr = curr->next;
    }

    if(curr->key == key)
    {
        pred->next = curr->next;
        ll_node_free(curr);
        pthread_spin_unlock(pred->lock);
        return 1;
    } else
    {
        pthread_spin_unlock(curr->lock);
        pthread_spin_unlock(pred->lock);
        return 0;
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
