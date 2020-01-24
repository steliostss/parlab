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
	/* other fields here? */
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
	pthread_spin_init(&(ret->lock),PTHREAD_PROCESS_SHARED);

	/* Other initializations here? */

	return ret;
}

/**
 * Free a linked list node.
 **/
static void ll_node_free(ll_node_t *ll_node)
{
	pthread_spin_destroy(&(ll_node->lock));
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

int validate(ll_node_t *curr,ll_node_t *next,ll_t *list) {
	ll_node_t *node=list->head;
	int ret=0;
	while (node->key <= curr->key) {
		if (node == curr) {
			ret= (curr->next == next);
			break;
		}
		node = node->next;
	}
	return ret;
}


int ll_contains(ll_t *ll, int key)
{
	int ret=0;
	ll_node_t *curr,*next;

	while(1){
		curr=ll->head;
		next=ll->head->next;
		while (next->key <= key) {
			curr = next;
			next = next->next;
		}
		pthread_spin_lock(&(curr->lock));
		pthread_spin_lock(&(next->lock));
		if (validate(curr,next,ll)) {
			if(next->key == key) {
				ret = 1;
			}
			//ret= (key == next->key);
			pthread_spin_unlock(&(curr->lock));
			pthread_spin_unlock(&(next->lock));
			break;
		}
		pthread_spin_unlock(&(curr->lock));
		pthread_spin_unlock(&(next->lock));
	}
	return ret;
}

int ll_add(ll_t *ll, int key)
{
	int ret=0;
	ll_node_t *curr,*next;
	ll_node_t *new_node;

	while (1) {
		curr=ll->head;
		next=ll->head->next;
		while (next->key <= key) {
			curr=next;
			next=next->next;
		}
		pthread_spin_lock(&(curr->lock));
		pthread_spin_lock(&(next->lock));
		if (validate(curr,next,ll)) {
			if (next->key != key) {
				ret = 1;
				new_node=ll_node_new(key);
				new_node->next=next;
				curr->next=new_node;
			}
			else {
				ret = 0;
			}
			pthread_spin_unlock(&(curr->lock));
			pthread_spin_unlock(&(next->lock));
			break;
		}
		pthread_spin_unlock(&(curr->lock));
		pthread_spin_unlock(&(next->lock));
	}
	return ret;
}

int ll_remove(ll_t *ll, int key)
{
	int ret=0;
	ll_node_t *curr,*next;

	while(1) {
		curr=ll->head;
		next=ll->head->next;
		while (next->key <= key) {
			if (key == next->key) break;
			curr=next;
			next=next->next;
		}
		pthread_spin_lock(&(curr->lock));
		pthread_spin_lock(&(next->lock));
		if (validate(curr,next,ll)) {
			if (key == next->key){
				ret = 1;
				curr->next = next->next;
				pthread_spin_unlock(&(curr->lock));
				pthread_spin_unlock(&(next->lock));
				ll_node_free(next);
			}
			else {
				ret = 0;
				pthread_spin_unlock(&(curr->lock));
				pthread_spin_unlock(&(next->lock));
			}
			break;
		}
		pthread_spin_unlock(&(curr->lock));
		pthread_spin_unlock(&(next->lock));
	}
	return ret;
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