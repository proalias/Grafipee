static class Vec3
{
  float x, y, z;

  Vec3()
  {
  }

  Vec3(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void normalize()
  {
    float length = length();
    x /= length;
    y /= length;
    z /= length;
  }

  float length()
  {
    return (float) Math.sqrt(x * x + y * y + z * z);
  }

  static Vec3 cross(Vec3 v1, Vec3 v2)
  {
    Vec3 res = new Vec3();
    res.x = v1.y * v2.z - v1.z * v2.y;
    res.y = v1.z * v2.x - v1.x * v2.z;
    res.z = v1.x * v2.y - v1.y * v2.x;
    return res;
  }

  static float dot(Vec3 v1, Vec3 v2)
  {
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
  }
  
  static Vec3 mul(Vec3 v, float d)
  {
    Vec3 res = new Vec3();
    res.x = v.x * d;
    res.y = v.y * d;
    res.z = v.z * d;
    return res;
  }

  void sub(Vec3 v1, Vec3 v2)
  {
    x = v1.x - v2.x;
    y = v1.y - v2.y;
    z = v1.z - v2.z;
  }
}
