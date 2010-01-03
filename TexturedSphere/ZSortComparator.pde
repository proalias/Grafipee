
import java.util.*;

class ZSortComparator implements Comparator{
  
  public int compare(Object p1, Object p2){
    int result = 0;
    Vec3D v1 = (Vec3D) p1;
    Vec3D v2 = (Vec3D) p2;
     
    if (v1.z > v2.z){ 
      result = -1;
    }
    if (v1.z < v2.z){ 
      result = 1;
    }
    return result;
  }
}
