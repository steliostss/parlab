#include <stdio.h>
#include <stdlib.h> /* rand() */
#include <limits.h>
#include <pthread.h> /* for pthread_spinlock_t */

#include "../common/alloc.h"
#include "ll.h"

typedef struct ll_node {
    int key;
    pthread_spinlock_t state;
    int marked;
    struct ll_node *next;
} ll_node_t;

struct linked_list {
    ll_node_t *head;
    pthread_mutex_t mymutex;
};

static ll_node_t *ll_node_new(int key)
{
    ll_node_t *ret;

    XMALLOC(ret, 1);
    ret->key = key;
    ret->next = NULL;
    int pshared;
    pthread_spin_init(&ret->state,pshared);
    ret->marked=1;

    return ret;
}

static void ll_node_free(ll_node_t *ll_node)
{
    XFREE(ll_node);
}

//Validate
int validate(ll_node_t *pred, ll_node_t *curr) {
    return pred->marked && curr->marked && pred->next==curr;
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

int ll_contains(ll_t *ll, int key)
{
    ll_node_t *curr;
    curr=ll->head;
    while (curr->key < key)
    {
        curr=curr->next;
    }

    return (curr->key==key)&&(curr->marked);
}

int ll_add(ll_t *ll, int key)
{
    int ret=0;
    ll_node_t *pred ,*curr,*new_node;
    while (1)
    {
        pred=ll->head;
        curr=pred->next;
        while (curr->key <= key)
        {
            pred=curr;curr=curr->next;
        }
        pthread_spin_lock(&pred->state);
        pthread_spin_lock(&curr->state);
        if (validate(pred,curr))
        {
            if (pred->key!=key)
            {
                new_node = ll_node_new(key);
                new_node->next = curr;
                pred->next = new_node;

                ret=1;
                pthread_spin_unlock(&pred->state);
                pthread_spin_unlock(&curr->state);
                return ret;
            }
            ret=0;
            pthread_spin_unlock(&pred->state);
            pthread_spin_unlock(&curr->state);
            return ret;
        }
        pthread_spin_unlock(&pred->state);
        pthread_spin_unlock(&curr->state);
    }
}

int ll_remove(ll_t *ll, int key)
{
    int ret=0;
    ll_node_t *pred ,*curr;
    while (1)
    {
        pred=ll->head;
        curr=pred->next;
        while (curr->key<key)
        {
            pred=curr;curr=curr->next;
        }
        pthread_spin_lock(&pred->state);
        pthread_spin_lock(&curr->state);
        if (validate(pred,curr))
        {
            if (curr->key==key)
            {
                curr->marked=0;
                pred->next=curr->next;
                ret=1;
                pthread_spin_unlock(&pred->state);
                pthread_spin_unlock(&curr->state);
                return ret;
            }
            ret=0;
            pthread_spin_unlock(&pred->state);
            pthread_spin_unlock(&curr->state);
            return ret;
        }
        pthread_spin_unlock(&pred->state);
        pthread_spin_unlock(&curr->state);
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