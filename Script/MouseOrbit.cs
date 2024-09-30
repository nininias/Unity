using UnityEngine;
using System.Collections;

public class MouseOrbit : MonoBehaviour {
	public Transform targetFocus;
    public GameObject targetObj;
    public Transform mainLight;
    public bool EnableDragObject = false;
    public bool EnableRotateLight = false;
    public float height = 0.0f;
	public float distance = 3.5f;
	[Range(0.1f, 4f)] public float ZoomWheelSpeed = 4.0f;

	public float minDistance = 1f;
	public float maxDistance = 4f;

	public float xSpeed = 250.0f;
	public float ySpeed = 120.0f;

    public float yMinLimit = -10;
    public float yMaxLimit = 60;

    public float objRotateSpeed = 500.0f;

    //
	private float x = 0.0f;
	private float y = 0.0f;
	
	private float normal_angle=0.0f;

	private float cur_distance=0;

	private float cur_xSpeed=0;
	private float cur_ySpeed=0;
	private float req_xSpeed=0;
	private float req_ySpeed=0;

	private float cur_ObjRotateSpeed=0;
	private float req_ObjRotateSpeed=0;

	private bool DraggingObject=false;
	private bool lastLMBState=false;
	private Collider[] surfaceColliders;
	private float bounds_MaxSize=20;

	[HideInInspector] public bool disableSteering=false;

	void Start () {
		Vector3 angles = transform.eulerAngles;
		x = angles.y;
		y = angles.x;

		Reset();
	}

	public void Reset() {
		lastLMBState = Input.GetMouseButton(0);

		disableSteering = false;

		cur_distance = distance;
		cur_xSpeed=0;
		cur_ySpeed=0;
		req_xSpeed=0;
		req_ySpeed=0;
		surfaceColliders = null;

        cur_ObjRotateSpeed = 0;
        req_ObjRotateSpeed = 0;
		
		if (targetObj) {
			Renderer[] renderers = targetObj.GetComponentsInChildren<Renderer>();
			Bounds bounds = new Bounds();
			bool initedBounds=false;
			foreach(Renderer rend in renderers) {
				if (!initedBounds) {
					initedBounds=true;
					bounds=rend.bounds;
				} else {
					bounds.Encapsulate(rend.bounds);
				}
			}
			Vector3 size = bounds.size;
			float dist = size.x>size.y ? size.x : size.y;
			dist = size.z>dist ? size.z : dist;
			bounds_MaxSize = dist;
			cur_distance += bounds_MaxSize*1.2f;
			
			surfaceColliders = targetObj.GetComponentsInChildren<Collider>();
		}
	}
    void LateUpdate () {
        if (Input.GetKeyDown(KeyCode.J))
        {
            EnableDragObject = !EnableDragObject;
        }
        if (Input.GetKeyDown(KeyCode.K))
        {
            EnableRotateLight = !EnableRotateLight;
        }    
        if (Input.GetKey(KeyCode.UpArrow))
        {
            height += 0.02f;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            height -= 0.02f;
        }
        var mousePosition = Input.mousePosition;
		if (mousePosition.x < Screen.width / 3 && mousePosition.y > (Screen.height - Screen.height / 3))
			return;

        if (targetObj && targetFocus) {

			if (!lastLMBState && Input.GetMouseButton(0)) {
				// mouse down
				DraggingObject=false;
                if(EnableDragObject == true)
			        DraggingObject=true;

			} else if (lastLMBState && !Input.GetMouseButton(0)) {
				// mouse up
				DraggingObject=false;
			}
			lastLMBState = Input.GetMouseButton(0);

			if (DraggingObject) {
				if (Input.GetMouseButton(0) && !disableSteering) {
                    req_ObjRotateSpeed += (Input.GetAxis("Mouse X") * objRotateSpeed * 0.02f - req_ObjRotateSpeed) *Time.deltaTime*10;
				} else {
                    req_ObjRotateSpeed += (0 - req_ObjRotateSpeed) *Time.deltaTime*4;
				}

				req_xSpeed += (0 - req_xSpeed)*Time.deltaTime*4;
				req_ySpeed += (0 - req_ySpeed)*Time.deltaTime*4;
			}
            else {
				if (Input.GetMouseButton(0) && !disableSteering) {
					req_xSpeed += (Input.GetAxis("Mouse X") * xSpeed * 0.02f - req_xSpeed)*Time.deltaTime*10;
					req_ySpeed += (Input.GetAxis("Mouse Y") * ySpeed * 0.02f - req_ySpeed)*Time.deltaTime*10;
				} else {
					req_xSpeed += (0 - req_xSpeed)*Time.deltaTime*4;
					req_ySpeed += (0 - req_ySpeed)*Time.deltaTime*4; 
				}

                req_ObjRotateSpeed += (0 - req_ObjRotateSpeed) *Time.deltaTime*4;
				//req_ObjySpeed += (0 - req_ObjySpeed)*Time.deltaTime*4;
                if (EnableDragObject == true)
                {
                    req_ObjRotateSpeed = 0.0f;
                    cur_ObjRotateSpeed = 0.0f;
                }
			}

			distance-=Input.GetAxis("Mouse ScrollWheel")*ZoomWheelSpeed;
			distance=Mathf.Clamp (distance, minDistance, maxDistance);

			cur_ObjRotateSpeed += (req_ObjRotateSpeed - cur_ObjRotateSpeed) *Time.deltaTime*20;
			//cur_ObjySpeed += (req_ObjySpeed-cur_ObjySpeed)*Time.deltaTime*20;
            if (EnableDragObject == true)
            {
                if (EnableRotateLight == true)
                {
                    if(mainLight != null)
                    mainLight.transform.Rotate(Vector3.up, -cur_ObjRotateSpeed, Space.World);
                }
                else
                targetObj.transform.Rotate(Vector3.up, -cur_ObjRotateSpeed, Space.World);
            }

            cur_xSpeed += (req_xSpeed-cur_xSpeed)*Time.deltaTime*20;
			cur_ySpeed += (req_ySpeed-cur_ySpeed)*Time.deltaTime*20;
			x += cur_xSpeed;
			y -= cur_ySpeed;

			y = ClampAngle(y, yMinLimit + normal_angle, yMaxLimit + normal_angle);

			if (surfaceColliders!=null && surfaceColliders.Length > 0) {
				RaycastHit hitInfo=new RaycastHit();
				Vector3 vdir=Vector3.Normalize(targetFocus.position-transform.position);
				float reqDistance=0.01f;
				bool surfaceFound=false;
				foreach(Collider surfaceCollider in surfaceColliders) {
					if (surfaceCollider.Raycast(new Ray(transform.position-vdir*bounds_MaxSize, vdir), out hitInfo, Mathf.Infinity)) {
						reqDistance = Mathf.Max(Vector3.Distance(hitInfo.point, targetFocus.position)+distance, reqDistance);
						surfaceFound=true;
					}
				}
				if (surfaceFound) {
					cur_distance += (reqDistance - cur_distance)*Time.deltaTime*4;
				}
			}
			else
				cur_distance = distance;

			Quaternion rotation = Quaternion.Euler(y, x, 0);
			Vector3 position = rotation * new Vector3(0.0f, 0.0f + height, -cur_distance) + targetFocus.position;
			
			transform.rotation = rotation;
			transform.position = position;
		}
	}
	
	static float ClampAngle (float angle, float min, float max) {
		if (angle < -360)
			angle += 360;
		if (angle > 360)
			angle -= 360;
		return Mathf.Clamp (angle, min, max);
	}
	
	public void set_normal_angle(float a) {
		normal_angle=a;
	}
}