"""External school system integration"""
import httpx

class SchoolAPIClient:
    def __init__(self, base_url: str):
        self.base_url = base_url
    
    async def sync_students(self):
        """Sync students from school system"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/students")
            return response.json()
    
    async def sync_teachers(self):
        """Sync teachers from school system"""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{self.base_url}/teachers")
            return response.json()