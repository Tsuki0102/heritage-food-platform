export class Storage {
  private static readonly PREFIX = 'heritage_food_'

  static set<T>(key: string, value: T): boolean {
    try {
      const fullKey = this.PREFIX + key
      const serializedValue = JSON.stringify(value)
      localStorage.setItem(fullKey, serializedValue)
      return true
    } catch (error) {
      console.error(`[Storage] Failed to set ${key}:`, error)
      return false
    }
  }

  static get<T>(key: string, defaultValue?: T): T | null {
    try {
      const fullKey = this.PREFIX + key
      const item = localStorage.getItem(fullKey)
      if (item === null) {
        return defaultValue ?? null
      }
      return JSON.parse(item) as T
    } catch (error) {
      console.error(`[Storage] Failed to get ${key}:`, error)
      return defaultValue ?? null
    }
  }

  static remove(key: string): boolean {
    try {
      const fullKey = this.PREFIX + key
      localStorage.removeItem(fullKey)
      return true
    } catch (error) {
      console.error(`[Storage] Failed to remove ${key}:`, error)
      return false
    }
  }

  static clear(): boolean {
    try {
      Object.keys(localStorage)
        .filter(key => key.startsWith(this.PREFIX))
        .forEach(key => localStorage.removeItem(key))
      return true
    } catch (error) {
      console.error('[Storage] Failed to clear:', error)
      return false
    }
  }

  static has(key: string): boolean {
    const fullKey = this.PREFIX + key
    return localStorage.getItem(fullKey) !== null
  }

  static keys(): string[] {
    return Object.keys(localStorage)
      .filter(key => key.startsWith(this.PREFIX))
      .map(key => key.substring(this.PREFIX.length))
  }
}

export default Storage
