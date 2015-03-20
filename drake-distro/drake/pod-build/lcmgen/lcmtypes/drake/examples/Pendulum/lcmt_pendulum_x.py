"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

import cStringIO as StringIO
import struct

class lcmt_pendulum_x(object):
    __slots__ = ["timestamp", "theta", "thetaDot"]

    def __init__(self):
        self.timestamp = 0
        self.theta = 0.0
        self.thetaDot = 0.0

    def encode(self):
        buf = StringIO.StringIO()
        buf.write(lcmt_pendulum_x._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">qdd", self.timestamp, self.theta, self.thetaDot))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = StringIO.StringIO(data)
        if buf.read(8) != lcmt_pendulum_x._get_packed_fingerprint():
            raise ValueError("Decode error")
        return lcmt_pendulum_x._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = lcmt_pendulum_x()
        self.timestamp, self.theta, self.thetaDot = struct.unpack(">qdd", buf.read(24))
        return self
    _decode_one = staticmethod(_decode_one)

    _hash = None
    def _get_hash_recursive(parents):
        if lcmt_pendulum_x in parents: return 0
        tmphash = (0xe63ab1618c3683f1) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff)  + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if lcmt_pendulum_x._packed_fingerprint is None:
            lcmt_pendulum_x._packed_fingerprint = struct.pack(">Q", lcmt_pendulum_x._get_hash_recursive([]))
        return lcmt_pendulum_x._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)

