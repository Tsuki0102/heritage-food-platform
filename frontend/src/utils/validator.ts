export class Validator {
  static phone(phone: string): boolean {
    const phoneRegex = /^1[3-9]\d{9}$/
    return phoneRegex.test(phone)
  }

  static email(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  static url(url: string): boolean {
    try {
      new URL(url)
      return true
    } catch {
      return false
    }
  }

  static required(value: any): boolean {
    if (value === null || value === undefined) {
      return false
    }
    if (typeof value === 'string') {
      return value.trim().length > 0
    }
    if (Array.isArray(value)) {
      return value.length > 0
    }
    return true
  }

  static minLength(value: string, min: number): boolean {
    return value.length >= min
  }

  static maxLength(value: string, max: number): boolean {
    return value.length <= max
  }

  static range(value: number, min: number, max: number): boolean {
    return value >= min && value <= max
  }

  static positiveNumber(value: number): boolean {
    return value > 0
  }

  static nonNegativeNumber(value: number): boolean {
    return value >= 0
  }
}

export default Validator
