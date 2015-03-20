"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

import cStringIO as StringIO
import struct

import command2_t

class deputy_cmd2_t(object):
    __slots__ = ["cmd", "pid", "actual_runid", "exit_code", "cpu_usage", "mem_vsize_bytes", "mem_rss_bytes", "sheriff_id"]

    def __init__(self):
        self.cmd = None
        self.pid = 0
        self.actual_runid = 0
        self.exit_code = 0
        self.cpu_usage = 0.0
        self.mem_vsize_bytes = 0
        self.mem_rss_bytes = 0
        self.sheriff_id = 0

    def encode(self):
        buf = StringIO.StringIO()
        buf.write(deputy_cmd2_t._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        assert self.cmd._get_packed_fingerprint() == command2_t.command2_t._get_packed_fingerprint()
        self.cmd._encode_one(buf)
        buf.write(struct.pack(">iiifqqi", self.pid, self.actual_runid, self.exit_code, self.cpu_usage, self.mem_vsize_bytes, self.mem_rss_bytes, self.sheriff_id))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = StringIO.StringIO(data)
        if buf.read(8) != deputy_cmd2_t._get_packed_fingerprint():
            raise ValueError("Decode error")
        return deputy_cmd2_t._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = deputy_cmd2_t()
        self.cmd = command2_t.command2_t._decode_one(buf)
        self.pid, self.actual_runid, self.exit_code, self.cpu_usage, self.mem_vsize_bytes, self.mem_rss_bytes, self.sheriff_id = struct.unpack(">iiifqqi", buf.read(36))
        return self
    _decode_one = staticmethod(_decode_one)

    _hash = None
    def _get_hash_recursive(parents):
        if deputy_cmd2_t in parents: return 0
        newparents = parents + [deputy_cmd2_t]
        tmphash = (0xe86006ec5c7fbaa+ command2_t.command2_t._get_hash_recursive(newparents)) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff)  + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if deputy_cmd2_t._packed_fingerprint is None:
            deputy_cmd2_t._packed_fingerprint = struct.pack(">Q", deputy_cmd2_t._get_hash_recursive([]))
        return deputy_cmd2_t._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)

