
class ArcBall
{
  float center_x, center_y, radius;
  Vec3 v_down, v_drag;
  Quat q_now, q_down, q_drag;
  boolean maxed = false;
  int sensorInc = 9;
  Vec3[] axisSet;
  Vec3 v;
  int axis;
  float x, y, z;
  float vx, vy;
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
    
    initSensorQ();
  }

  void mousePressed(float mX, float mY)
  {
    println(">>>>>>>>>>>>>>>>>>>>>>mousePressed "+mX+","+mY);
    v_down = mouse_to_sphere(mX, mY);
    q_down.set(q_now);
    q_drag.reset();
  }

  void mouseDragged(float mX, float mY)
  {
    println("mouseDragged "+mX+","+mY);
    v_drag = mouse_to_sphere(mX, mY);
    q_drag.set(Vec3.dot(v_down, v_drag), Vec3.cross(v_down, v_drag));
  }
  
  
  void initSensorQ()
  {
    v_down = sensor_to_sphere(width / 2, height /2);
    q_down.set(q_now);
    q_drag.reset();
  }

/*
  void sensorQ()
  {
    if (maxed){
      initSensorQ();
      maxed = false;
    }else if (sensorInc > 30){
      sensorInc = 0;
    }
    v_drag = sensor_to_sphere(sensorVect.x, sensorVect.y);
    q_drag.set(Vec3.dot(v_down, v_drag), Vec3.cross(v_down, v_drag));
  }
*/

  
  void run()
  {
    
    q_now = Quat.mul(q_drag, q_down);
    applyQuat2Matrix(q_now);
    //updateSensorQ();
    //q_down = q_now;
  }


  void updateRotation(Vec3 oldVect, Vec3 newVect){
      println("oldVect:"+oldVect.x+","+oldVect.y+" newVect:"+newVect.x+","+newVect.y);
      Vec3 diffVect = new Vec3();
      diffVect.sub(oldVect,newVect);
      
      println("diffVect:"+diffVect.x+","+diffVect.y);
      
      v_drag = mouse_to_sphere(diffVect.x + center_x, diffVect.y + center_y);
      println("v_drag.x="+v_drag.x+","+v_drag.x+"="+v_drag.x);
      
      
      
      q_drag.set(Vec3.dot(v_down, v_drag), Vec3.cross(v_down, v_drag));
      q_now = Quat.mul(q_drag, q_down);
      applyQuat2Matrix(q_now);
      
      //if(
      //q_down.set(q_now);
      //q_drag.reset();
      
  }

  Vec3 sensor_to_sphere(float x, float y)
  {
    println("sensor_to_sphere");
    v = new Vec3();
    v.x = (x) / radius;
    v.y = (y) / radius;

    float mag = v.x * v.x + v.y * v.y;
    if (mag > 1.0f)
    {
      println("-----------------MAXED-----------:mag = "+ mag +",vx="+x+",vy="+y+",time:"+millis());
      println("center_x="+center_x+",center_y="+center_y);
      maxed = true;
      initSensorQ();
      v.normalize();

    }
    else
    {
      v.z = sqrt(1.0f - mag);
    }
    
    return (axis == -1) ? v : constrain_vector(v, axisSet[axis]);
  }

  Vec3 mouse_to_sphere(float x, float y)
  {
    println("mouse_to_sphere");
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
    println("constrain_vector");
    Vec3 res = new Vec3();
    res.sub(vector, Vec3.mul(axis, Vec3.dot(axis, vector)));
    res.normalize();
    return res;
  }

  void applyQuat2Matrix(Quat q)
  {
    println("applyQuat2Matrix");
    // instead of transforming q into a matrix and applying it...

    float[] aa = q.getValue();
    rotate(aa[0], aa[1], aa[2], aa[3]);
    println("aa[0]="+aa[0]+", aa[1]="+aa[1]+", aa[2]="+aa[2]+", aa[3]="+aa[3]+");");
  }
}
