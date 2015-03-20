"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

import cStringIO as StringIO
import struct

class image_sync_t(object):
    __slots__ = ["utime"]

    def __init__(self):
        self.utime = 0

    def encode(self):
        buf = StringIO.StringIO()
        buf.write(image_sync_t._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">q", self.utime))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = StringIO.StringIO(data)
        if buf.read(8) != image_sync_t._get_packed_fingerprint():
            raise ValueError("Decode error")
        return image_sync_t._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = image_sync_t()
        self.utime = struct.unpack(">q", buf.read(8))[0]
        return self
    _decode_one = staticmethod(_decode_one)

    _hash = None
    def _get_hash_recursive(parents):
        if image_sync_t in parents: return 0
        tmphash = (0xa686a0e0f882d897) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff)  + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if image_sync_t._packed_fingerprint is None:
            image_sync_t._packed_fingerprint = struct.pack(">Q", image_sync_t._get_hash_recursive([]))
        return image_sync_t._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)

