export const runtime = "edge";

export async function GET() {
  return Response.json({ 
    message: "API test endpoint working", 
    timestamp: new Date().toISOString() 
  });
}
