/* LCM type definition class file
 * This file was automatically generated by lcm-gen
 * DO NOT MODIFY BY HAND!!!!
 */

package drake;
 
import java.io.*;
import java.util.*;
import lcm.lcm.*;
 
public final class lcmt_viewer_load_robot implements lcm.lcm.LCMEncodable
{
    public int num_links;
    public drake.lcmt_viewer_link_data link[];
 
    public lcmt_viewer_load_robot()
    {
    }
 
    public static final long LCM_FINGERPRINT;
    public static final long LCM_FINGERPRINT_BASE = 0x739e6927d8bcec39L;
 
    static {
        LCM_FINGERPRINT = _hashRecursive(new ArrayList<Class<?>>());
    }
 
    public static long _hashRecursive(ArrayList<Class<?>> classes)
    {
        if (classes.contains(drake.lcmt_viewer_load_robot.class))
            return 0L;
 
        classes.add(drake.lcmt_viewer_load_robot.class);
        long hash = LCM_FINGERPRINT_BASE
             + drake.lcmt_viewer_link_data._hashRecursive(classes)
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
        outs.writeInt(this.num_links); 
 
        for (int a = 0; a < this.num_links; a++) {
            this.link[a]._encodeRecursive(outs); 
        }
 
    }
 
    public lcmt_viewer_load_robot(byte[] data) throws IOException
    {
        this(new LCMDataInputStream(data));
    }
 
    public lcmt_viewer_load_robot(DataInput ins) throws IOException
    {
        if (ins.readLong() != LCM_FINGERPRINT)
            throw new IOException("LCM Decode error: bad fingerprint");
 
        _decodeRecursive(ins);
    }
 
    public static drake.lcmt_viewer_load_robot _decodeRecursiveFactory(DataInput ins) throws IOException
    {
        drake.lcmt_viewer_load_robot o = new drake.lcmt_viewer_load_robot();
        o._decodeRecursive(ins);
        return o;
    }
 
    public void _decodeRecursive(DataInput ins) throws IOException
    {
        this.num_links = ins.readInt();
 
        this.link = new drake.lcmt_viewer_link_data[(int) num_links];
        for (int a = 0; a < this.num_links; a++) {
            this.link[a] = drake.lcmt_viewer_link_data._decodeRecursiveFactory(ins);
        }
 
    }
 
    public drake.lcmt_viewer_load_robot copy()
    {
        drake.lcmt_viewer_load_robot outobj = new drake.lcmt_viewer_load_robot();
        outobj.num_links = this.num_links;
 
        outobj.link = new drake.lcmt_viewer_link_data[(int) num_links];
        for (int a = 0; a < this.num_links; a++) {
            outobj.link[a] = this.link[a].copy();
        }
 
        return outobj;
    }
 
}
