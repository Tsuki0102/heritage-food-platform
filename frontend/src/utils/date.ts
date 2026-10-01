export class DateUtils {
  static format(date: Date | string | number, format: string = 'YYYY-MM-DD HH:mm:ss'): string {
    const d = new Date(date)
    if (isNaN(d.getTime())) {
      return ''
    }

    const year = d.getFullYear()
    const month = String(d.getMonth() + 1).padStart(2, '0')
    const day = String(d.getDate()).padStart(2, '0')
    const hours = String(d.getHours()).padStart(2, '0')
    const minutes = String(d.getMinutes()).padStart(2, '0')
    const seconds = String(d.getSeconds()).padStart(2, '0')

    return format
      .replace('YYYY', String(year))
      .replace('MM', month)
      .replace('DD', day)
      .replace('HH', hours)
      .replace('mm', minutes)
      .replace('ss', seconds)
  }

  static formatChinese(date: Date | string | number): string {
    return this.format(date, 'YYYY年MM月DD日 HH:mm')
  }

  static formatDate(date: Date | string | number): string {
    return this.format(date, 'YYYY-MM-DD')
  }

  static formatTime(date: Date | string | number): string {
    return this.format(date, 'HH:mm')
  }

  static relativeTime(date: Date | string | number): string {
    const d = new Date(date)
    const now = new Date()
    const diff = now.getTime() - d.getTime()

    const seconds = Math.floor(diff / 1000)
    const minutes = Math.floor(seconds / 60)
    const hours = Math.floor(minutes / 60)
    const days = Math.floor(hours / 24)

    if (seconds < 60) {
      return '刚刚'
    } else if (minutes < 60) {
      return `${minutes}分钟前`
    } else if (hours < 24) {
      return `${hours}小时前`
    } else if (days < 7) {
      return `${days}天前`
    } else {
      return this.formatDate(date)
    }
  }

  static isToday(date: Date | string | number): boolean {
    const d = new Date(date)
    const today = new Date()
    return d.getFullYear() === today.getFullYear() &&
           d.getMonth() === today.getMonth() &&
           d.getDate() === today.getDate()
  }

  static isYesterday(date: Date | string | number): boolean {
    const d = new Date(date)
    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    return d.getFullYear() === yesterday.getFullYear() &&
           d.getMonth() === yesterday.getMonth() &&
           d.getDate() === yesterday.getDate()
  }
}

export default DateUtils
