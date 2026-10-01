export interface Store {
  id: number
  name: string
  address: string
  longitude: number
  latitude: number
  contact?: string
  openingHours?: string
  introduction: string
  score: number
  images?: string[]
  foods?: any[]
  activities?: any[]
  comments?: any[]
}
