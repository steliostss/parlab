#include "lock.h"
#include "../common/alloc.h"

// This can't be inside the struct for whatever reason.
__thread int mySlotIndex;

// TODO: Maybe try the <stdatomic.h> library for the atomic operations
struct lock_struct {
	int* flag;
	int tail; // Perform only atomic ops on this
	int size;
};

lock_t *lock_init(int nthreads)
{
	lock_t *lock;

	XMALLOC(lock, 1);
	lock->size = nthreads;
    XMALLOC(lock->flag, nthreads);
    lock->flag[0] = 1;
    //__sync_add_and_fetch(&lock->tail, 0);
    lock->tail = 0;
	return lock;
}

void lock_free(lock_t *lock)
{
    XFREE(lock->flag);
	XFREE(lock);
}

void lock_acquire(lock_t *lock)
{
    lock_t *l = lock;

    /*
     * sync_fetch_and_add(p, v) atomically adds v to *p
     * and returns the previous value.
     */
    int slot = __sync_fetch_and_add(&l->tail, 1) % l->size;
    mySlotIndex = slot;
    while(!l->flag[slot]) /* do nothing */ ;
}

void lock_release(lock_t *lock)
{
    lock_t *l = lock;
    int slot = mySlotIndex;
    lock->flag[slot] = 0;
    l->flag[(slot+1) % l->size] = 1;
}
