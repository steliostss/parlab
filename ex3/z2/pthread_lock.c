#include "lock.h"
#include "../common/alloc.h"
#include <pthread.h>

struct lock_struct
{
    pthread_spinlock_t spinlock;
};

lock_t *lock_init(int nthreads)
{
	lock_t *lock;

	/*
	 * XMALLOC is a macro so lock is allocated in-place
	 */
	XMALLOC(lock, 1);

	/*
	 * The pthread_spin_init() function allocates any resources required for
	 * the use of the spin lock referred to by lock and initializes the lock
     * to be in the unlocked state.
     *
     * PTHREAD_PROCESS_PRIVATE indicates the lock is only shared by threads
     * in the same process. Alternatively, use PTHREAD_PROCESS_SHARED.
	 */
	pthread_spin_init(&lock->spinlock, PTHREAD_PROCESS_PRIVATE);
	return lock;
}

void lock_free(lock_t *lock)
{
    /*
     * The pthread_spin_destroy() function destroys a previously initialized
     * spin lock, freeing any resources that were allocated for that lock.
    */
    pthread_spin_destroy(&lock->spinlock);
	XFREE(lock);
}

void lock_acquire(lock_t *lock)
{
    // Any error checks we should perform here? pthread_spin_lock() returns 0 on success.
     pthread_spin_lock(&lock->spinlock);
}

void lock_release(lock_t *lock)
{
    // Ditto the above comment.
    pthread_spin_unlock(&lock->spinlock);
}
