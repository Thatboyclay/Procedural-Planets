//In progress C# to C++ conversion

#include <>
#include <>

UCLASS()
class AActor : public TerrainFace  
{
    GENERATE_BODY()
    
    public:
      
    StaticMesh* mesh;
      
    UPROPERTY(EditAnywhere, Category="ProceduralTerrain")
    int resolution;
      
    FVector3 localUp;
    FVector3 axisA;
    FVector3 axisB;

    public TerrainFace(StaticMesh mesh, int resolution, FVector3 localUp)
    {
        this.mesh = mesh;
        this.resolution = resolution;
        this.localUp = localUp;

        axisA = new FVector3(localUp.y, localUp.z, localUp.x);
        axisB = FVector3.Cross(localUp, axisA);
    }

    public void ConstructMesh()
    {
        FVector3[] vertices = new FVector3[resolution * resolution];
        int[] triangles = new int[(resolution - 1) * (resolution - 1) * 6];
        int triIndex = 0;

        for (int y = 0; y < resolution; y++)
        {
            for (int x = 0; x < resolution; x++)
            {
                int i = x + y * resolution;
                FVector2 percent = new Vector2(x, y) / (resolution - 1);
                FVector3 pointOnUnitCube = localUp + (percent.x - .5f) * 2 * axisA + (percent.y - .5f) * 2 * axisB;
                FVector3 pointOnUnitSphere = pointOnUnitCube.normalized;
                vertices[i] = pointOnUnitSphere;

                if (x != resolution - 1 && y != resolution - 1)
                {
                    triangles[triIndex] = i;
                    triangles[triIndex + 1] = i + resolution + 1;
                    triangles[triIndex + 2] = i + resolution;

                    triangles[triIndex + 3] = i;
                    triangles[triIndex + 4] = i + 1;
                    triangles[triIndex + 5] = i + resolution + 1;
                    triIndex += 6;
                }
            }
        }
        mesh.Clear();
        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.RecalculateNormals();
    }
}
