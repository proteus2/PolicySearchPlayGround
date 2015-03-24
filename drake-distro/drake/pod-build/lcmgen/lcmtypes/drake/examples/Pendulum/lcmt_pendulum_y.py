"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

import cStringIO as StringIO
import struct

class lcmt_pendulum_y(object):
    __slots__ = ["timestamp", "theta", "tau"]

    def __init__(self):
        self.timestamp = 0
        self.theta = 0.0
        self.tau = 0.0

    def encode(self):
        buf = StringIO.StringIO()
        buf.write(lcmt_pendulum_y._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">qdd", self.timestamp, self.theta, self.tau))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = StringIO.StringIO(data)
        if buf.read(8) != lcmt_pendulum_y._get_packed_fingerprint():
            raise ValueError("Decode error")
        return lcmt_pendulum_y._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = lcmt_pendulum_y()
        self.timestamp, self.theta, self.tau = struct.unpack(">qdd", buf.read(24))
        return self
    _decode_one = staticmethod(_decode_one)

    _hash = None
    def _get_hash_recursive(parents):
        if lcmt_pendulum_y in parents: return 0
        tmphash = (0x82916ff66ab3b5be) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff)  + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if lcmt_pendulum_y._packed_fingerprint is None:
            lcmt_pendulum_y._packed_fingerprint = struct.pack(">Q", lcmt_pendulum_y._get_hash_recursive([]))
        return lcmt_pendulum_y._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)
