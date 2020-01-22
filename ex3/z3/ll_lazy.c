#include <stdio.h>
#include <stdlib.h> /* rand() */
#include <limits.h>
#include <pthread.h> /* for pthread_spinlock_t */

#include "../common/alloc.h"
#include "ll.h"

typedef struct ll_node {
	int key;
	int marked;
    pthread_spinlock_t *lock;
	struct ll_node *next;

} ll_node_t;

struct linked_list {
	ll_node_t *head;
};

static ll_node_t *ll_node_new(int key)
{
	ll_node_t *ret;

	XMALLOC(ret, 1);
	ret->key = key;
	ret->marked = 0;
	ret->next = NULL;
    XMALLOC(ret->lock, 1);  //Clang-Tidy gives warning about this
    pthread_spin_init(ret->lock, PTHREAD_PROCESS_PRIVATE);

	return ret;
}

static void ll_node_free(ll_node_t *ll_node)
{
    // TODO: Consider if this should be used at all on optimistc locking
    pthread_spin_destroy(ll_node->lock);
    XFREE(ll_node->lock);
    XFREE(ll_node);
}

ll_t *ll_new()
{
	ll_t *ret;

	XMALLOC(ret, 1);
	ret->head = ll_node_new(-1);
	ret->head->next = ll_node_new(INT_MAX);
	ret->head->next->next = NULL;

	return ret;
}

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

static int ll_validate(ll_t *ll, ll_node_t * pred, ll_node_t *curr)
{
	return(pred->next == curr && pred->marked == 0 && pred->next->marked == 0);
}

int ll_contains(ll_t *ll, int key)
{
    ll_node_t *curr;
    curr = ll->head;
    ll_node_t *succ;
    succ = curr->next;

    while(curr->key < key)
	{
		curr = succ;
		succ = succ->next;
	}
	return (curr->marked == 0 && curr->key == key);
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
		int retval = 0;
        if(ll_validate(ll, pred, succ))
        {
			pthread_spin_lock(pred->lock);
	        pthread_spin_lock(succ->lock);

            if (succ->key != key) 
			{
                ll_node_t *new_node = ll_node_new(key);
                pred->next = new_node;
                new_node->next = succ;
				retval = 1;
            }
            else
				retval = 0;

			pthread_spin_unlock(succ->lock);
			pthread_spin_unlock(pred->lock);
        }
		return retval;
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
				curr->marked = 1;
                pred->next = curr->next;
                pthread_spin_unlock(pred->lock);
                ll_node_free(curr);
                return 1;
            }
            else
            {
                pthread_spin_unlock(pred->lock);
                pthread_spin_unlock(curr->lock);
                return 0;
            }
        }
        else
        {
            pthread_spin_unlock(pred->lock);
            pthread_spin_unlock(curr->lock);
        }
    }
}

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
