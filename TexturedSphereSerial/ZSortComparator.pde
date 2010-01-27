
import java.util.*;

class ZSortComparator implements Comparator{
  
  public int compare(Object p1, Object p2){
    int result = 0;
    PVector v1 = (PVector) p1;
    PVector v2 = (PVector) p2;
     
    if (v1.z > v2.z){ 
      result = 1;
    }
    if (v1.z < v2.z){ 
      result = -1;
    }
    return result;
  }
}
