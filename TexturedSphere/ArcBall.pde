
class ArcBall
{
  float center_x, center_y, radius;
  Vec3 v_down, v_drag;
  Quat q_now, q_down, q_drag;
  Vec3[] axisSet;
  Vec3 v;
  int axis;
  float x, y, z;
  ArcBall(float center_x, float center_y, float radius)
  {
    this.center_x = center_x;
    this.center_y = center_y;
    this.radius = radius;

    v_down = new Vec3();
    v_drag = new Vec3();

    q_now = new Quat();
    q_down = new Quat();
    q_drag = new Quat();

    axisSet = new Vec3[] {new Vec3(1.0f, 0.0f, 0.0f), new Vec3(0.0f, 1.0f, 0.0f), new Vec3(0.0f, 0.0f, 1.0f)};
    axis = -1;  // no constraints...
  }

  void mousePressed()
  {
    v_down = mouse_to_sphere(mouseX, mouseY);
    q_down.set(q_now);
    q_drag.reset();
  }

  void mouseDragged()
  {
    v_drag = mouse_to_sphere(mouseX, mouseY);
    q_drag.set(Vec3.dot(v_down, v_drag), Vec3.cross(v_down, v_drag));
  }

  void run()
  {
    q_now = Quat.mul(q_drag, q_down);
    applyQuat2Matrix(q_now);
  }

  Vec3 mouse_to_sphere(float x, float y)
  {
    v = new Vec3();
    v.x = (x - center_x) / radius;
    v.y = (y - center_y) / radius;

    float mag = v.x * v.x + v.y * v.y;
    if (mag > 1.0f)
    {
      v.normalize();
    }
    else
    {
      v.z = sqrt(1.0f - mag);
    }

    return (axis == -1) ? v : constrain_vector(v, axisSet[axis]);
  }

  Vec3 constrain_vector(Vec3 vector, Vec3 axis)
  {
    Vec3 res = new Vec3();
    res.sub(vector, Vec3.mul(axis, Vec3.dot(axis, vector)));
    res.normalize();
    return res;
  }

  void applyQuat2Matrix(Quat q)
  {
    // instead of transforming q into a matrix and applying it...

    float[] aa = q.getValue();
    rotate(aa[0], aa[1], aa[2], aa[3]);
  }
}
