#include <stdio.h>
#include <stdlib.h> /* rand() */
#include <limits.h>
#include "../common/alloc.h"
#include "ll.h"

/*
 * This is defined mainly to distinct variables declared for use as combinations of
 * pointer and marking bit.
 */
typedef int comb_t;

typedef struct ll_node {
    int key;
    comb_t field; // Next node pointer + "marked" bit
} ll_node_t;

/*
 * Macros to assist in creating and extracting values
 * using the combined type. The 2 last ones get an entire
 * node and do the extraction.
 */
#define COMBINE(P, B) ((comb_t)((int)P | B))
#define GETNEXTPOINTER(N) ((ll_node_t *)(N->field & 0xfffffffe))
#define GETMARKEDBIT(N) (N->field & 0x00000001)

// Similar to the get() method of the java atomic reference class
static ll_node_t *getnextandcheck(ll_node_t *n, int *marked)
{
    // Get the field out first in order to perform both operations on the same value.
    comb_t f = n->field;
    marked[0] = f & 0x00000001;

    return (ll_node_t *)(f & 0xfffffffe);
}

/*
 * Similar to the compareAndSet() method in Java, checks if node->field == expected and on
 * success sets it to update. Returns 1 on sucess.
 */
static int compare_and_set(ll_node_t *node, comb_t expected, comb_t update)
{
    return __sync_bool_compare_and_swap(&node->field, expected, update);
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
    int marked[1] = {0};
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
                int snip = compare_and_set(
                        GETNEXTPOINTER(pred),
                        COMBINE(curr, 0),
                        COMBINE(succ, 0)
                );

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
    int marked[1] = {0};
    ll_node_t *curr = ll->head;
    while (curr->key < key)
    {
        curr = GETNEXTPOINTER(curr);
    }

    // *succ is defined in lesson slides, but never used
    ll_node_t *succ = getnextandcheck(curr, marked);
	return (curr->key == key && !marked[0]);

	// Alternatively:
	// return (curr->key == key && !GETMARKEDBIT(curr))
}

int ll_add(ll_t *ll, int key)
{
    // Lesson slides define a bool that is never used here:
    // int splice
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

            if (compare_and_set(
                    GETNEXTPOINTER(pred),
                    COMBINE(curr, 0),
                    COMBINE(node, 0)
            )) return 1;
        }
    }
}

int ll_remove(ll_t *ll, int key)
{
    int snip;
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
            snip = compare_and_set(
                    GETNEXTPOINTER(curr),
                    COMBINE(succ, 0),
                    COMBINE(succ, 1)
                    );
            if(!snip) continue;
            compare_and_set(
                    GETNEXTPOINTER(pred),
                    COMBINE(curr, 0),
                    COMBINE(succ, 0)
                    );
            return 1;
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
		curr = GETNEXTPOINTER(curr);
	}
	printf(" ]\n");
}
