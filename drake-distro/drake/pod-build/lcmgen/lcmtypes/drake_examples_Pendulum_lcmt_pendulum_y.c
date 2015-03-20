/** THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT MODIFY
 * BY HAND!!
 *
 * Generated by lcm-gen
 **/

#include <string.h>
#include "drake_examples_Pendulum_lcmt_pendulum_y.h"

static int __drake_examples_Pendulum_lcmt_pendulum_y_hash_computed;
static int64_t __drake_examples_Pendulum_lcmt_pendulum_y_hash;

int64_t __drake_examples_Pendulum_lcmt_pendulum_y_hash_recursive(const __lcm_hash_ptr *p)
{
    const __lcm_hash_ptr *fp;
    for (fp = p; fp != NULL; fp = fp->parent)
        if (fp->v == __drake_examples_Pendulum_lcmt_pendulum_y_get_hash)
            return 0;

    const __lcm_hash_ptr cp = { p, (void*)__drake_examples_Pendulum_lcmt_pendulum_y_get_hash };
    (void) cp;

    int64_t hash = 0x82916ff66ab3b5beLL
         + __int64_t_hash_recursive(&cp)
         + __double_hash_recursive(&cp)
         + __double_hash_recursive(&cp)
        ;

    return (hash<<1) + ((hash>>63)&1);
}

int64_t __drake_examples_Pendulum_lcmt_pendulum_y_get_hash(void)
{
    if (!__drake_examples_Pendulum_lcmt_pendulum_y_hash_computed) {
        __drake_examples_Pendulum_lcmt_pendulum_y_hash = __drake_examples_Pendulum_lcmt_pendulum_y_hash_recursive(NULL);
        __drake_examples_Pendulum_lcmt_pendulum_y_hash_computed = 1;
    }

    return __drake_examples_Pendulum_lcmt_pendulum_y_hash;
}

int __drake_examples_Pendulum_lcmt_pendulum_y_encode_array(void *buf, int offset, int maxlen, const drake_examples_Pendulum_lcmt_pendulum_y *p, int elements)
{
    int pos = 0, thislen, element;

    for (element = 0; element < elements; element++) {

        thislen = __int64_t_encode_array(buf, offset + pos, maxlen - pos, &(p[element].timestamp), 1);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __double_encode_array(buf, offset + pos, maxlen - pos, &(p[element].theta), 1);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __double_encode_array(buf, offset + pos, maxlen - pos, &(p[element].tau), 1);
        if (thislen < 0) return thislen; else pos += thislen;

    }
    return pos;
}

int drake_examples_Pendulum_lcmt_pendulum_y_encode(void *buf, int offset, int maxlen, const drake_examples_Pendulum_lcmt_pendulum_y *p)
{
    int pos = 0, thislen;
    int64_t hash = __drake_examples_Pendulum_lcmt_pendulum_y_get_hash();

    thislen = __int64_t_encode_array(buf, offset + pos, maxlen - pos, &hash, 1);
    if (thislen < 0) return thislen; else pos += thislen;

    thislen = __drake_examples_Pendulum_lcmt_pendulum_y_encode_array(buf, offset + pos, maxlen - pos, p, 1);
    if (thislen < 0) return thislen; else pos += thislen;

    return pos;
}

int __drake_examples_Pendulum_lcmt_pendulum_y_encoded_array_size(const drake_examples_Pendulum_lcmt_pendulum_y *p, int elements)
{
    int size = 0, element;
    for (element = 0; element < elements; element++) {

        size += __int64_t_encoded_array_size(&(p[element].timestamp), 1);

        size += __double_encoded_array_size(&(p[element].theta), 1);

        size += __double_encoded_array_size(&(p[element].tau), 1);

    }
    return size;
}

int drake_examples_Pendulum_lcmt_pendulum_y_encoded_size(const drake_examples_Pendulum_lcmt_pendulum_y *p)
{
    return 8 + __drake_examples_Pendulum_lcmt_pendulum_y_encoded_array_size(p, 1);
}

int __drake_examples_Pendulum_lcmt_pendulum_y_decode_array(const void *buf, int offset, int maxlen, drake_examples_Pendulum_lcmt_pendulum_y *p, int elements)
{
    int pos = 0, thislen, element;

    for (element = 0; element < elements; element++) {

        thislen = __int64_t_decode_array(buf, offset + pos, maxlen - pos, &(p[element].timestamp), 1);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __double_decode_array(buf, offset + pos, maxlen - pos, &(p[element].theta), 1);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __double_decode_array(buf, offset + pos, maxlen - pos, &(p[element].tau), 1);
        if (thislen < 0) return thislen; else pos += thislen;

    }
    return pos;
}

int __drake_examples_Pendulum_lcmt_pendulum_y_decode_array_cleanup(drake_examples_Pendulum_lcmt_pendulum_y *p, int elements)
{
    int element;
    for (element = 0; element < elements; element++) {

        __int64_t_decode_array_cleanup(&(p[element].timestamp), 1);

        __double_decode_array_cleanup(&(p[element].theta), 1);

        __double_decode_array_cleanup(&(p[element].tau), 1);

    }
    return 0;
}

int drake_examples_Pendulum_lcmt_pendulum_y_decode(const void *buf, int offset, int maxlen, drake_examples_Pendulum_lcmt_pendulum_y *p)
{
    int pos = 0, thislen;
    int64_t hash = __drake_examples_Pendulum_lcmt_pendulum_y_get_hash();

    int64_t this_hash;
    thislen = __int64_t_decode_array(buf, offset + pos, maxlen - pos, &this_hash, 1);
    if (thislen < 0) return thislen; else pos += thislen;
    if (this_hash != hash) return -1;

    thislen = __drake_examples_Pendulum_lcmt_pendulum_y_decode_array(buf, offset + pos, maxlen - pos, p, 1);
    if (thislen < 0) return thislen; else pos += thislen;

    return pos;
}

int drake_examples_Pendulum_lcmt_pendulum_y_decode_cleanup(drake_examples_Pendulum_lcmt_pendulum_y *p)
{
    return __drake_examples_Pendulum_lcmt_pendulum_y_decode_array_cleanup(p, 1);
}

int __drake_examples_Pendulum_lcmt_pendulum_y_clone_array(const drake_examples_Pendulum_lcmt_pendulum_y *p, drake_examples_Pendulum_lcmt_pendulum_y *q, int elements)
{
    int element;
    for (element = 0; element < elements; element++) {

        __int64_t_clone_array(&(p[element].timestamp), &(q[element].timestamp), 1);

        __double_clone_array(&(p[element].theta), &(q[element].theta), 1);

        __double_clone_array(&(p[element].tau), &(q[element].tau), 1);

    }
    return 0;
}

drake_examples_Pendulum_lcmt_pendulum_y *drake_examples_Pendulum_lcmt_pendulum_y_copy(const drake_examples_Pendulum_lcmt_pendulum_y *p)
{
    drake_examples_Pendulum_lcmt_pendulum_y *q = (drake_examples_Pendulum_lcmt_pendulum_y*) malloc(sizeof(drake_examples_Pendulum_lcmt_pendulum_y));
    __drake_examples_Pendulum_lcmt_pendulum_y_clone_array(p, q, 1);
    return q;
}

void drake_examples_Pendulum_lcmt_pendulum_y_destroy(drake_examples_Pendulum_lcmt_pendulum_y *p)
{
    __drake_examples_Pendulum_lcmt_pendulum_y_decode_array_cleanup(p, 1);
    free(p);
}

int drake_examples_Pendulum_lcmt_pendulum_y_publish(lcm_t *lc, const char *channel, const drake_examples_Pendulum_lcmt_pendulum_y *p)
{
      int max_data_size = drake_examples_Pendulum_lcmt_pendulum_y_encoded_size (p);
      uint8_t *buf = (uint8_t*) malloc (max_data_size);
      if (!buf) return -1;
      int data_size = drake_examples_Pendulum_lcmt_pendulum_y_encode (buf, 0, max_data_size, p);
      if (data_size < 0) {
          free (buf);
          return data_size;
      }
      int status = lcm_publish (lc, channel, buf, data_size);
      free (buf);
      return status;
}

struct _drake_examples_Pendulum_lcmt_pendulum_y_subscription_t {
    drake_examples_Pendulum_lcmt_pendulum_y_handler_t user_handler;
    void *userdata;
    lcm_subscription_t *lc_h;
};
static
void drake_examples_Pendulum_lcmt_pendulum_y_handler_stub (const lcm_recv_buf_t *rbuf,
                            const char *channel, void *userdata)
{
    int status;
    drake_examples_Pendulum_lcmt_pendulum_y p;
    memset(&p, 0, sizeof(drake_examples_Pendulum_lcmt_pendulum_y));
    status = drake_examples_Pendulum_lcmt_pendulum_y_decode (rbuf->data, 0, rbuf->data_size, &p);
    if (status < 0) {
        fprintf (stderr, "error %d decoding drake_examples_Pendulum_lcmt_pendulum_y!!!\n", status);
        return;
    }

    drake_examples_Pendulum_lcmt_pendulum_y_subscription_t *h = (drake_examples_Pendulum_lcmt_pendulum_y_subscription_t*) userdata;
    h->user_handler (rbuf, channel, &p, h->userdata);

    drake_examples_Pendulum_lcmt_pendulum_y_decode_cleanup (&p);
}

drake_examples_Pendulum_lcmt_pendulum_y_subscription_t* drake_examples_Pendulum_lcmt_pendulum_y_subscribe (lcm_t *lcm,
                    const char *channel,
                    drake_examples_Pendulum_lcmt_pendulum_y_handler_t f, void *userdata)
{
    drake_examples_Pendulum_lcmt_pendulum_y_subscription_t *n = (drake_examples_Pendulum_lcmt_pendulum_y_subscription_t*)
                       malloc(sizeof(drake_examples_Pendulum_lcmt_pendulum_y_subscription_t));
    n->user_handler = f;
    n->userdata = userdata;
    n->lc_h = lcm_subscribe (lcm, channel,
                                 drake_examples_Pendulum_lcmt_pendulum_y_handler_stub, n);
    if (n->lc_h == NULL) {
        fprintf (stderr,"couldn't reg drake_examples_Pendulum_lcmt_pendulum_y LCM handler!\n");
        free (n);
        return NULL;
    }
    return n;
}

int drake_examples_Pendulum_lcmt_pendulum_y_subscription_set_queue_capacity (drake_examples_Pendulum_lcmt_pendulum_y_subscription_t* subs,
                              int num_messages)
{
    return lcm_subscription_set_queue_capacity (subs->lc_h, num_messages);
}

int drake_examples_Pendulum_lcmt_pendulum_y_unsubscribe(lcm_t *lcm, drake_examples_Pendulum_lcmt_pendulum_y_subscription_t* hid)
{
    int status = lcm_unsubscribe (lcm, hid->lc_h);
    if (0 != status) {
        fprintf(stderr,
           "couldn't unsubscribe drake_examples_Pendulum_lcmt_pendulum_y_handler %p!\n", hid);
        return -1;
    }
    free (hid);
    return 0;
}

