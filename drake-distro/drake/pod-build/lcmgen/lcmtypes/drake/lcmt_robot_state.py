"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

import cStringIO as StringIO
import struct

class lcmt_robot_state(object):
    __slots__ = ["timestamp", "num_robots", "robot_name", "num_joints", "joint_robot", "joint_name", "joint_position", "joint_velocity"]

    def __init__(self):
        self.timestamp = 0
        self.num_robots = 0
        self.robot_name = []
        self.num_joints = 0
        self.joint_robot = []
        self.joint_name = []
        self.joint_position = []
        self.joint_velocity = []

    def encode(self):
        buf = StringIO.StringIO()
        buf.write(lcmt_robot_state._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">qi", self.timestamp, self.num_robots))
        for i0 in range(self.num_robots):
            __robot_name_encoded = self.robot_name[i0].encode('utf-8')
            buf.write(struct.pack('>I', len(__robot_name_encoded)+1))
            buf.write(__robot_name_encoded)
            buf.write("\0")
        buf.write(struct.pack(">i", self.num_joints))
        buf.write(struct.pack('>%di' % self.num_joints, *self.joint_robot[:self.num_joints]))
        for i0 in range(self.num_joints):
            __joint_name_encoded = self.joint_name[i0].encode('utf-8')
            buf.write(struct.pack('>I', len(__joint_name_encoded)+1))
            buf.write(__joint_name_encoded)
            buf.write("\0")
        buf.write(struct.pack('>%df' % self.num_joints, *self.joint_position[:self.num_joints]))
        buf.write(struct.pack('>%df' % self.num_joints, *self.joint_velocity[:self.num_joints]))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = StringIO.StringIO(data)
        if buf.read(8) != lcmt_robot_state._get_packed_fingerprint():
            raise ValueError("Decode error")
        return lcmt_robot_state._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = lcmt_robot_state()
        self.timestamp, self.num_robots = struct.unpack(">qi", buf.read(12))
        self.robot_name = []
        for i0 in range(self.num_robots):
            __robot_name_len = struct.unpack('>I', buf.read(4))[0]
            self.robot_name.append(buf.read(__robot_name_len)[:-1].decode('utf-8', 'replace'))
        self.num_joints = struct.unpack(">i", buf.read(4))[0]
        self.joint_robot = struct.unpack('>%di' % self.num_joints, buf.read(self.num_joints * 4))
        self.joint_name = []
        for i0 in range(self.num_joints):
            __joint_name_len = struct.unpack('>I', buf.read(4))[0]
            self.joint_name.append(buf.read(__joint_name_len)[:-1].decode('utf-8', 'replace'))
        self.joint_position = struct.unpack('>%df' % self.num_joints, buf.read(self.num_joints * 4))
        self.joint_velocity = struct.unpack('>%df' % self.num_joints, buf.read(self.num_joints * 4))
        return self
    _decode_one = staticmethod(_decode_one)

    _hash = None
    def _get_hash_recursive(parents):
        if lcmt_robot_state in parents: return 0
        tmphash = (0x5ee54c65cb66563d) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff)  + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if lcmt_robot_state._packed_fingerprint is None:
            lcmt_robot_state._packed_fingerprint = struct.pack(">Q", lcmt_robot_state._get_hash_recursive([]))
        return lcmt_robot_state._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)

