
import damkjer.ocd.*;

BillBoard billboard;
PFont font;
Camera camera1;
float rotX;
float rotY;

void setup()
{
  size( 300, 300, P3D );

  billboard = new BillBoard( (PGraphics3D)(this.g) );
  
  camera1 = new Camera( this, width/2, height/2, width, width/2, height/2, 0 );
  rotX = 0.0;
  rotY = 0.0;
  
  font = loadFont( "Copperplate.vlw" );
  textFont( font, 48 );

}

void draw()
{
  background( 0 );
  camera1.feed();
  pushMatrix();
  translate( width/2, height/2 );
  fill( 80, 200, 124 );
  stroke( 255 );
  box( 50 );
  line( -50, 50, -50, 50, 50, -50 );
  line( -50, 50, -50, -50, -50, -50 );
  line( -50, 50, -50, -50, 50, 50 );

  fill( 80, 124, 200 );
  
  billboard.BeginBillboard(50, 50, -50);
    text( "x", 0, 0 );
  billboard.EndBillboard();  
  
  billboard.BeginBillboard(-50, -50, -50);
    text( "y", 0, 0 );
  billboard.EndBillboard();  
  
  billboard.BeginBillboard(-50, 50, 50 );
    text( "z", 0, 0 );
  billboard.EndBillboard();
  
  popMatrix();
}

// rotate the camera when the mouse is dragged 
void mouseDragged()
{

  rotY = mouseX - pmouseX;
  rotX = mouseY - pmouseY;
  camera1.circle( radians( rotY) );
  camera1.arc( radians( rotX ) );
}

class BillBoard
{
  PGraphics3D m_engine;
  PMatrix m_inv;

  // From setup() call billboard = new Billboard( (PGraphics3)(this.g));
  BillBoard( PGraphics3D engine )
  {
    m_engine = engine;
  }

  // x, y, and z are the local coordinates of the object
  // you want to billboard  
  void BeginBillboard( float x, float y, float z )
  {
    m_inv = m_engine.camera.get();
    m_inv.invert();
    float[] in = new float[4];
    float[] out = new float[4];

    in[0] = x; in[1] = y; in[2] = z; in[3] = 1;
    m_engine.camera.mult( in,out );
    
    pushMatrix();

    applyMatrix( m_inv.m00, m_inv.m01, m_inv.m02, m_inv.m03,
	m_inv.m10, m_inv.m11, m_inv.m12, m_inv.m13,
	m_inv.m20, m_inv.m21, m_inv.m22, m_inv.m23,
	m_inv.m30, m_inv.m31, m_inv.m32, m_inv.m33 );
	
    translate( out[0], out[1], out[2] );
  }
  
  void EndBillboard()
  {
    popMatrix();
  }
}
