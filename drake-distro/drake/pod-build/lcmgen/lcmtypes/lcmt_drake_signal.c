/** THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT MODIFY
 * BY HAND!!
 *
 * Generated by lcm-gen
 **/

#include <string.h>
#include "lcmt_drake_signal.h"

static int __lcmt_drake_signal_hash_computed;
static int64_t __lcmt_drake_signal_hash;

int64_t __lcmt_drake_signal_hash_recursive(const __lcm_hash_ptr *p)
{
    const __lcm_hash_ptr *fp;
    for (fp = p; fp != NULL; fp = fp->parent)
        if (fp->v == __lcmt_drake_signal_get_hash)
            return 0;

    const __lcm_hash_ptr cp = { p, (void*)__lcmt_drake_signal_get_hash };
    (void) cp;

    int64_t hash = 0x236e73ecd6fc3932LL
         + __int32_t_hash_recursive(&cp)
         + __double_hash_recursive(&cp)
         + __string_hash_recursive(&cp)
         + __int64_t_hash_recursive(&cp)
        ;

    return (hash<<1) + ((hash>>63)&1);
}

int64_t __lcmt_drake_signal_get_hash(void)
{
    if (!__lcmt_drake_signal_hash_computed) {
        __lcmt_drake_signal_hash = __lcmt_drake_signal_hash_recursive(NULL);
        __lcmt_drake_signal_hash_computed = 1;
    }

    return __lcmt_drake_signal_hash;
}

int __lcmt_drake_signal_encode_array(void *buf, int offset, int maxlen, const lcmt_drake_signal *p, int elements)
{
    int pos = 0, thislen, element;

    for (element = 0; element < elements; element++) {

        thislen = __int32_t_encode_array(buf, offset + pos, maxlen - pos, &(p[element].dim), 1);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __double_encode_array(buf, offset + pos, maxlen - pos, p[element].val, p[element].dim);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __string_encode_array(buf, offset + pos, maxlen - pos, p[element].coord, p[element].dim);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __int64_t_encode_array(buf, offset + pos, maxlen - pos, &(p[element].timestamp), 1);
        if (thislen < 0) return thislen; else pos += thislen;

    }
    return pos;
}

int lcmt_drake_signal_encode(void *buf, int offset, int maxlen, const lcmt_drake_signal *p)
{
    int pos = 0, thislen;
    int64_t hash = __lcmt_drake_signal_get_hash();

    thislen = __int64_t_encode_array(buf, offset + pos, maxlen - pos, &hash, 1);
    if (thislen < 0) return thislen; else pos += thislen;

    thislen = __lcmt_drake_signal_encode_array(buf, offset + pos, maxlen - pos, p, 1);
    if (thislen < 0) return thislen; else pos += thislen;

    return pos;
}

int __lcmt_drake_signal_encoded_array_size(const lcmt_drake_signal *p, int elements)
{
    int size = 0, element;
    for (element = 0; element < elements; element++) {

        size += __int32_t_encoded_array_size(&(p[element].dim), 1);

        size += __double_encoded_array_size(p[element].val, p[element].dim);

        size += __string_encoded_array_size(p[element].coord, p[element].dim);

        size += __int64_t_encoded_array_size(&(p[element].timestamp), 1);

    }
    return size;
}

int lcmt_drake_signal_encoded_size(const lcmt_drake_signal *p)
{
    return 8 + __lcmt_drake_signal_encoded_array_size(p, 1);
}

int __lcmt_drake_signal_decode_array(const void *buf, int offset, int maxlen, lcmt_drake_signal *p, int elements)
{
    int pos = 0, thislen, element;

    for (element = 0; element < elements; element++) {

        thislen = __int32_t_decode_array(buf, offset + pos, maxlen - pos, &(p[element].dim), 1);
        if (thislen < 0) return thislen; else pos += thislen;

        p[element].val = (double*) lcm_malloc(sizeof(double) * p[element].dim);
        thislen = __double_decode_array(buf, offset + pos, maxlen - pos, p[element].val, p[element].dim);
        if (thislen < 0) return thislen; else pos += thislen;

        p[element].coord = (char**) lcm_malloc(sizeof(char*) * p[element].dim);
        thislen = __string_decode_array(buf, offset + pos, maxlen - pos, p[element].coord, p[element].dim);
        if (thislen < 0) return thislen; else pos += thislen;

        thislen = __int64_t_decode_array(buf, offset + pos, maxlen - pos, &(p[element].timestamp), 1);
        if (thislen < 0) return thislen; else pos += thislen;

    }
    return pos;
}

int __lcmt_drake_signal_decode_array_cleanup(lcmt_drake_signal *p, int elements)
{
    int element;
    for (element = 0; element < elements; element++) {

        __int32_t_decode_array_cleanup(&(p[element].dim), 1);

        __double_decode_array_cleanup(p[element].val, p[element].dim);
        if (p[element].val) free(p[element].val);

        __string_decode_array_cleanup(p[element].coord, p[element].dim);
        if (p[element].coord) free(p[element].coord);

        __int64_t_decode_array_cleanup(&(p[element].timestamp), 1);

    }
    return 0;
}

int lcmt_drake_signal_decode(const void *buf, int offset, int maxlen, lcmt_drake_signal *p)
{
    int pos = 0, thislen;
    int64_t hash = __lcmt_drake_signal_get_hash();

    int64_t this_hash;
    thislen = __int64_t_decode_array(buf, offset + pos, maxlen - pos, &this_hash, 1);
    if (thislen < 0) return thislen; else pos += thislen;
    if (this_hash != hash) return -1;

    thislen = __lcmt_drake_signal_decode_array(buf, offset + pos, maxlen - pos, p, 1);
    if (thislen < 0) return thislen; else pos += thislen;

    return pos;
}

int lcmt_drake_signal_decode_cleanup(lcmt_drake_signal *p)
{
    return __lcmt_drake_signal_decode_array_cleanup(p, 1);
}

int __lcmt_drake_signal_clone_array(const lcmt_drake_signal *p, lcmt_drake_signal *q, int elements)
{
    int element;
    for (element = 0; element < elements; element++) {

        __int32_t_clone_array(&(p[element].dim), &(q[element].dim), 1);

        q[element].val = (double*) lcm_malloc(sizeof(double) * q[element].dim);
        __double_clone_array(p[element].val, q[element].val, p[element].dim);

        q[element].coord = (char**) lcm_malloc(sizeof(char*) * q[element].dim);
        __string_clone_array(p[element].coord, q[element].coord, p[element].dim);

        __int64_t_clone_array(&(p[element].timestamp), &(q[element].timestamp), 1);

    }
    return 0;
}

lcmt_drake_signal *lcmt_drake_signal_copy(const lcmt_drake_signal *p)
{
    lcmt_drake_signal *q = (lcmt_drake_signal*) malloc(sizeof(lcmt_drake_signal));
    __lcmt_drake_signal_clone_array(p, q, 1);
    return q;
}

void lcmt_drake_signal_destroy(lcmt_drake_signal *p)
{
    __lcmt_drake_signal_decode_array_cleanup(p, 1);
    free(p);
}

int lcmt_drake_signal_publish(lcm_t *lc, const char *channel, const lcmt_drake_signal *p)
{
      int max_data_size = lcmt_drake_signal_encoded_size (p);
      uint8_t *buf = (uint8_t*) malloc (max_data_size);
      if (!buf) return -1;
      int data_size = lcmt_drake_signal_encode (buf, 0, max_data_size, p);
      if (data_size < 0) {
          free (buf);
          return data_size;
      }
      int status = lcm_publish (lc, channel, buf, data_size);
      free (buf);
      return status;
}

struct _lcmt_drake_signal_subscription_t {
    lcmt_drake_signal_handler_t user_handler;
    void *userdata;
    lcm_subscription_t *lc_h;
};
static
void lcmt_drake_signal_handler_stub (const lcm_recv_buf_t *rbuf,
                            const char *channel, void *userdata)
{
    int status;
    lcmt_drake_signal p;
    memset(&p, 0, sizeof(lcmt_drake_signal));
    status = lcmt_drake_signal_decode (rbuf->data, 0, rbuf->data_size, &p);
    if (status < 0) {
        fprintf (stderr, "error %d decoding lcmt_drake_signal!!!\n", status);
        return;
    }

    lcmt_drake_signal_subscription_t *h = (lcmt_drake_signal_subscription_t*) userdata;
    h->user_handler (rbuf, channel, &p, h->userdata);

    lcmt_drake_signal_decode_cleanup (&p);
}

lcmt_drake_signal_subscription_t* lcmt_drake_signal_subscribe (lcm_t *lcm,
                    const char *channel,
                    lcmt_drake_signal_handler_t f, void *userdata)
{
    lcmt_drake_signal_subscription_t *n = (lcmt_drake_signal_subscription_t*)
                       malloc(sizeof(lcmt_drake_signal_subscription_t));
    n->user_handler = f;
    n->userdata = userdata;
    n->lc_h = lcm_subscribe (lcm, channel,
                                 lcmt_drake_signal_handler_stub, n);
    if (n->lc_h == NULL) {
        fprintf (stderr,"couldn't reg lcmt_drake_signal LCM handler!\n");
        free (n);
        return NULL;
    }
    return n;
}

int lcmt_drake_signal_subscription_set_queue_capacity (lcmt_drake_signal_subscription_t* subs,
                              int num_messages)
{
    return lcm_subscription_set_queue_capacity (subs->lc_h, num_messages);
}

int lcmt_drake_signal_unsubscribe(lcm_t *lcm, lcmt_drake_signal_subscription_t* hid)
{
    int status = lcm_unsubscribe (lcm, hid->lc_h);
    if (0 != status) {
        fprintf(stderr,
           "couldn't unsubscribe lcmt_drake_signal_handler %p!\n", hid);
        return -1;
    }
    free (hid);
    return 0;
}
