from motor.motor_asyncio import AsyncIOMotorCollection
from app.model.post import Post, NewPost
from typing import List, Dict
from datetime import datetime
from fastapi import HTTPException
from app.model.types import PyObjectId


class AppService:
    collection: AsyncIOMotorCollection

    def __init__(self, collection: AsyncIOMotorCollection):
        self.collection = collection

    async def get_posts(self) -> List[Post]:
        res = self.collection.find()

        return [Post(**post) async for post in res]
    
    async def create_post(self, post: NewPost) -> NewPost:
        newPost = post.dict()
        newPost["created_at"] = datetime.now()
        res = await self.collection.insert_one(newPost)

        if res:
            return Post(
                id=res.inserted_id,
                **newPost)
        
    async def delete_post(self, id: PyObjectId) -> Dict:
        res = await self.collection.delete_one(
            {"_id": id}
        )

        print(res.deleted_count)

        if res.deleted_count == 1:
            return {
                "message": "Post deleted successfully"
            }
        else:
            raise HTTPException(status_code=404, detail="Post not found")