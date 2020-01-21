#include <stdio.h>
#include <stdlib.h> /* rand() */
#include <limits.h>
#include "../common/alloc.h"
#include "ll.h"

/*
 * This is defined mainly to distinct variables declared for use as combinations of
 * point64_ter and marking bit.
 */
typedef int64_t comb_t;

typedef struct ll_node {
    int key;
    comb_t field; // Next node point64_ter + "marked" bit
} ll_node_t;

/*
 * Macros to assist in creating and extracting values
 * using the combined type. The 2 last ones get an entire
 * node and do the extraction.
 */
#define LSB_MASK 0x0000000000000001
#define BIT_MASK 0xfffffffffffffffe
#define COMBINE(P, B) ((comb_t)((int64_t)P | B))
#define GETNEXTPOINTER(N) ((ll_node_t *)(N->field & BIT_MASK))
#define GETMARKEDBIT(N) (N->field & LSB_MASK)

// Similar to the get() method of the java atomic reference class
static ll_node_t *getnextandcheck(ll_node_t *n, int64_t *marked)
{
    // Get the field out first in order to perform both operations on the same value.
    comb_t f = n->field;
    marked[0] = f & LSB_MASK;

    return (ll_node_t *)(f & BIT_MASK);
}

/*
 * Similar to the compareAndSet() method in Java, checks if node->field == expected and on
 * success sets it to update. Returns 1 on sucess.
 */
static int64_t compare_and_set(ll_node_t *node, comb_t expected, comb_t update)
{
    int val = __sync_bool_compare_and_swap(&node, expected, update);
    return val;
}

struct linked_list {
	ll_node_t *head;
	/* other fields here? */
};


// For use in the find() function
typedef struct window
{
    ll_node_t *start;
    ll_node_t *end;
} window_t;


static window_t *find(ll_t *ll, int key)
{
    ll_node_t *pred, *curr, *succ;
    int64_t marked[1] = {0};
retry: while (1)
    {
        pred = ll->head;
        curr = GETNEXTPOINTER(pred);
        while (1)
        {
            // Possibly replacing function body here is faster
            succ = getnextandcheck(curr, marked);
            while (marked[0])
            {
                int64_t snip  = __sync_bool_compare_and_swap(&pred->field, COMBINE(curr,0), COMBINE(succ,0));

                if(!snip) goto retry;
                curr = succ;
                succ = getnextandcheck(curr, marked);
            }

            if (curr->key >= key)
            {
                window_t *ret;
                XMALLOC(ret, 1);
                ret->start = pred;
                ret->end = curr;
                return ret;
            }
            pred = curr;
            curr = succ;
        }
    }
}

/**
 * Create a new linked list node.
 **/
static ll_node_t *ll_node_new(int key)
{
	ll_node_t *ret;

	XMALLOC(ret, 1);
	ret->key = key;
    ret->field = 1;

	return ret;
}

/**
 * Free a linked list node.
 **/
static void ll_node_free(ll_node_t *ll_node)
{
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
	ll_node_t *last = ll_node_new(INT_MAX);
	ret->head->field = COMBINE(last, 0);
	last->field = COMBINE(NULL, 0);

	return ret;
}

/**
 * Free a linked list and all its contained nodes.
 **/
void ll_free(ll_t *ll)
{
	ll_node_t *next, *curr = ll->head;
	while (curr) {
		next = GETNEXTPOINTER(curr);
		ll_node_free(curr);
		curr = next;
	}
	XFREE(ll);
}

int ll_contains(ll_t *ll, int key)
{
    int64_t marked[1] = {0};
    ll_node_t *curr = ll->head;
    while (curr->key < key)
    {
        curr = GETNEXTPOINTER(curr);
    }

    // *succ is defined in lesson slides, but never used
    ll_node_t *succ = getnextandcheck(curr, marked);
	int val = (curr->key == key && !marked[0]);
    return val;

	// Alternatively:
	// return (curr->key == key && !GETMARKEDBIT(curr))
}

int ll_add(ll_t *ll, int key)
{
    // Lesson slides define a bool that is never used here:
    // int64_t splice
    while (1)
    {
        window_t *window = find(ll, key);
        ll_node_t *pred = window->start;
        ll_node_t *curr = window->end;
        if (curr->key == key)
        {
            return 0;
        }
        else
        {
            ll_node_t *node = ll_node_new(key);
            node->field = COMBINE(curr, 0);

//            if (compare_and_set(
//                    GETNEXTPOINTER(pred),
//                    COMBINE(curr, 0),
//                    COMBINE(node, 0)
//            )) return 1;
            int val = __sync_bool_compare_and_swap(&pred->field, COMBINE(curr,0), COMBINE(node,0));
            return val;
        }
    }
}

int ll_remove(ll_t *ll, int key)
{
    int64_t snip;
    while (1)
    {
        window_t *window = find(ll, key);
        ll_node_t *pred = window->start;
        ll_node_t *curr = window->end;
        if (curr->key != key)
        {
            return 0;
        }
        else
        {
            ll_node_t *succ = GETNEXTPOINTER(curr);

            snip = __sync_bool_compare_and_swap(&curr->field, COMBINE(succ,0), COMBINE(succ,1));
            if(!snip) continue;

            __sync_bool_compare_and_swap(&pred->field, COMBINE(curr,0), COMBINE(succ,0));

            return 1;
        }
    }
}

/**
 * Print64_t a linked list.
 **/
void ll_print64_t(ll_t *ll)
{
	ll_node_t *curr = ll->head;
	printf("LIST [");
	while (curr) {
		if (curr->key == INT_MAX)
			printf(" -> MAX");
		else
			printf(" -> %d", curr->key);
		curr = GETNEXTPOINTER(curr);
	}
	printf(" ]\n");
}
