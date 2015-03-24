/* LCM type definition class file
 * This file was automatically generated by lcm-gen
 * DO NOT MODIFY BY HAND!!!!
 */

package drake;
 
import java.io.*;
import java.util.*;
import lcm.lcm.*;
 
public final class lcmt_viewer_link_data implements lcm.lcm.LCMEncodable
{
    public String name;
    public int robot_num;
    public int num_geom;
    public drake.lcmt_viewer_geometry_data geom[];
 
    public lcmt_viewer_link_data()
    {
    }
 
    public static final long LCM_FINGERPRINT;
    public static final long LCM_FINGERPRINT_BASE = 0x4b645ec7a5743a2aL;
 
    static {
        LCM_FINGERPRINT = _hashRecursive(new ArrayList<Class<?>>());
    }
 
    public static long _hashRecursive(ArrayList<Class<?>> classes)
    {
        if (classes.contains(drake.lcmt_viewer_link_data.class))
            return 0L;
 
        classes.add(drake.lcmt_viewer_link_data.class);
        long hash = LCM_FINGERPRINT_BASE
             + drake.lcmt_viewer_geometry_data._hashRecursive(classes)
            ;
        classes.remove(classes.size() - 1);
        return (hash<<1) + ((hash>>63)&1);
    }
 
    public void encode(DataOutput outs) throws IOException
    {
        outs.writeLong(LCM_FINGERPRINT);
        _encodeRecursive(outs);
    }
 
    public void _encodeRecursive(DataOutput outs) throws IOException
    {
        char[] __strbuf = null;
        __strbuf = new char[this.name.length()]; this.name.getChars(0, this.name.length(), __strbuf, 0); outs.writeInt(__strbuf.length+1); for (int _i = 0; _i < __strbuf.length; _i++) outs.write(__strbuf[_i]); outs.writeByte(0); 
 
        outs.writeInt(this.robot_num); 
 
        outs.writeInt(this.num_geom); 
 
        for (int a = 0; a < this.num_geom; a++) {
            this.geom[a]._encodeRecursive(outs); 
        }
 
    }
 
    public lcmt_viewer_link_data(byte[] data) throws IOException
    {
        this(new LCMDataInputStream(data));
    }
 
    public lcmt_viewer_link_data(DataInput ins) throws IOException
    {
        if (ins.readLong() != LCM_FINGERPRINT)
            throw new IOException("LCM Decode error: bad fingerprint");
 
        _decodeRecursive(ins);
    }
 
    public static drake.lcmt_viewer_link_data _decodeRecursiveFactory(DataInput ins) throws IOException
    {
        drake.lcmt_viewer_link_data o = new drake.lcmt_viewer_link_data();
        o._decodeRecursive(ins);
        return o;
    }
 
    public void _decodeRecursive(DataInput ins) throws IOException
    {
        char[] __strbuf = null;
        __strbuf = new char[ins.readInt()-1]; for (int _i = 0; _i < __strbuf.length; _i++) __strbuf[_i] = (char) (ins.readByte()&0xff); ins.readByte(); this.name = new String(__strbuf);
 
        this.robot_num = ins.readInt();
 
        this.num_geom = ins.readInt();
 
        this.geom = new drake.lcmt_viewer_geometry_data[(int) num_geom];
        for (int a = 0; a < this.num_geom; a++) {
            this.geom[a] = drake.lcmt_viewer_geometry_data._decodeRecursiveFactory(ins);
        }
 
    }
 
    public drake.lcmt_viewer_link_data copy()
    {
        drake.lcmt_viewer_link_data outobj = new drake.lcmt_viewer_link_data();
        outobj.name = this.name;
 
        outobj.robot_num = this.robot_num;
 
        outobj.num_geom = this.num_geom;
 
        outobj.geom = new drake.lcmt_viewer_geometry_data[(int) num_geom];
        for (int a = 0; a < this.num_geom; a++) {
            outobj.geom[a] = this.geom[a].copy();
        }
 
        return outobj;
    }
 
}
