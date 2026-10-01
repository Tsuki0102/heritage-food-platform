// 类型定义文件

export interface Comment {
  id: number
  userId: number
  nickname: string
  avatar: string
  score?: number
  content: string
  createTime: string
  liked?: boolean
  likeCount?: number
}

export interface Food {
  id: number
  name: string
  region: string
  taste: string
  heritageLevel: string
  history: string
  ingredients: string
  process: string
  coverImage: string
  averageScore: number
  collectionCount: number
  viewCount: number
  comments?: Comment[]
}