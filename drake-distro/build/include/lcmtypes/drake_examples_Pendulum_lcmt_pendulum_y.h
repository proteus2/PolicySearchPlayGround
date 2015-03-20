/** THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT MODIFY
 * BY HAND!!
 *
 * Generated by lcm-gen
 **/

#include <stdint.h>
#include <stdlib.h>
#include <lcm/lcm_coretypes.h>
#include <lcm/lcm.h>

#ifndef _drake_examples_Pendulum_lcmt_pendulum_y_h
#define _drake_examples_Pendulum_lcmt_pendulum_y_h

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _drake_examples_Pendulum_lcmt_pendulum_y drake_examples_Pendulum_lcmt_pendulum_y;
struct _drake_examples_Pendulum_lcmt_pendulum_y
{
    int64_t    timestamp;
    double     theta;
    double     tau;
};

drake_examples_Pendulum_lcmt_pendulum_y   *drake_examples_Pendulum_lcmt_pendulum_y_copy(const drake_examples_Pendulum_lcmt_pendulum_y *p);
void drake_examples_Pendulum_lcmt_pendulum_y_destroy(drake_examples_Pendulum_lcmt_pendulum_y *p);

typedef struct _drake_examples_Pendulum_lcmt_pendulum_y_subscription_t drake_examples_Pendulum_lcmt_pendulum_y_subscription_t;
typedef void(*drake_examples_Pendulum_lcmt_pendulum_y_handler_t)(const lcm_recv_buf_t *rbuf,
             const char *channel, const drake_examples_Pendulum_lcmt_pendulum_y *msg, void *user);

int drake_examples_Pendulum_lcmt_pendulum_y_publish(lcm_t *lcm, const char *channel, const drake_examples_Pendulum_lcmt_pendulum_y *p);
drake_examples_Pendulum_lcmt_pendulum_y_subscription_t* drake_examples_Pendulum_lcmt_pendulum_y_subscribe(lcm_t *lcm, const char *channel, drake_examples_Pendulum_lcmt_pendulum_y_handler_t f, void *userdata);
int drake_examples_Pendulum_lcmt_pendulum_y_unsubscribe(lcm_t *lcm, drake_examples_Pendulum_lcmt_pendulum_y_subscription_t* hid);
int drake_examples_Pendulum_lcmt_pendulum_y_subscription_set_queue_capacity(drake_examples_Pendulum_lcmt_pendulum_y_subscription_t* subs,
                              int num_messages);


int  drake_examples_Pendulum_lcmt_pendulum_y_encode(void *buf, int offset, int maxlen, const drake_examples_Pendulum_lcmt_pendulum_y *p);
int  drake_examples_Pendulum_lcmt_pendulum_y_decode(const void *buf, int offset, int maxlen, drake_examples_Pendulum_lcmt_pendulum_y *p);
int  drake_examples_Pendulum_lcmt_pendulum_y_decode_cleanup(drake_examples_Pendulum_lcmt_pendulum_y *p);
int  drake_examples_Pendulum_lcmt_pendulum_y_encoded_size(const drake_examples_Pendulum_lcmt_pendulum_y *p);

// LCM support functions. Users should not call these
int64_t __drake_examples_Pendulum_lcmt_pendulum_y_get_hash(void);
int64_t __drake_examples_Pendulum_lcmt_pendulum_y_hash_recursive(const __lcm_hash_ptr *p);
int     __drake_examples_Pendulum_lcmt_pendulum_y_encode_array(void *buf, int offset, int maxlen, const drake_examples_Pendulum_lcmt_pendulum_y *p, int elements);
int     __drake_examples_Pendulum_lcmt_pendulum_y_decode_array(const void *buf, int offset, int maxlen, drake_examples_Pendulum_lcmt_pendulum_y *p, int elements);
int     __drake_examples_Pendulum_lcmt_pendulum_y_decode_array_cleanup(drake_examples_Pendulum_lcmt_pendulum_y *p, int elements);
int     __drake_examples_Pendulum_lcmt_pendulum_y_encoded_array_size(const drake_examples_Pendulum_lcmt_pendulum_y *p, int elements);
int     __drake_examples_Pendulum_lcmt_pendulum_y_clone_array(const drake_examples_Pendulum_lcmt_pendulum_y *p, drake_examples_Pendulum_lcmt_pendulum_y *q, int elements);

#ifdef __cplusplus
}
#endif

#endif
