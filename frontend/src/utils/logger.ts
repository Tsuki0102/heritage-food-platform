export enum LogLevel {
  DEBUG = 0,
  INFO = 1,
  WARN = 2,
  ERROR = 3,
  FATAL = 4
}

export enum LogCategory {
  USER = 'User',
  COMMUNITY = 'Community',
  USER_DATA = 'UserData',
  NETWORK = 'Network',
  STORAGE = 'Storage',
  VALIDATION = 'Validation',
  UI = 'UI'
}

interface LogEntry {
  timestamp: string
  level: LogLevel
  category: LogCategory
  message: string
  data?: any
  stack?: string
}

class Logger {
  private static instance: Logger
  private logs: LogEntry[] = []
  private maxLogs = 1000
  private minLevel = LogLevel.INFO
  private enableConsole = true
  private enableStorage = true

  static getInstance(): Logger {
    if (!Logger.instance) {
      Logger.instance = new Logger()
    }
    return Logger.instance
  }

  private constructor() {
    this.loadSettings()
    this.setupErrorHandlers()
  }

  private loadSettings(): void {
    const settings = localStorage.getItem('logger_settings')
    if (settings) {
      try {
        const parsed = JSON.parse(settings)
        this.minLevel = parsed.minLevel ?? LogLevel.INFO
        this.enableConsole = parsed.enableConsole ?? true
        this.enableStorage = parsed.enableStorage ?? true
      } catch (error) {
        console.error('[Logger] Failed to load settings:', error)
      }
    }
  }

  private saveSettings(): void {
    try {
      localStorage.setItem('logger_settings', JSON.stringify({
        minLevel: this.minLevel,
        enableConsole: this.enableConsole,
        enableStorage: this.enableStorage
      }))
    } catch (error) {
      console.error('[Logger] Failed to save settings:', error)
    }
  }

  private setupErrorHandlers(): void {
    window.addEventListener('error', (event) => {
      this.error(LogCategory.UI, 'Unhandled error', {
        message: event.message,
        filename: event.filename,
        lineno: event.lineno,
        colno: event.colno
      }, event.error?.stack)
    })

    window.addEventListener('unhandledrejection', (event) => {
      this.error(LogCategory.UI, 'Unhandled promise rejection', {
        reason: event.reason
      })
    })
  }

  private log(level: LogLevel, category: LogCategory, message: string, data?: any, stack?: string): void {
    if (level < this.minLevel) {
      return
    }

    const entry: LogEntry = {
      timestamp: new Date().toISOString(),
      level,
      category,
      message,
      data,
      stack
    }

    this.logs.push(entry)
    
    if (this.logs.length > this.maxLogs) {
      this.logs.shift()
    }

    if (this.enableStorage) {
      this.saveLogs()
    }

    if (this.enableConsole) {
      this.logToConsole(entry)
    }
  }

  private logToConsole(entry: LogEntry): void {
    const prefix = `[${entry.timestamp}] [${entry.category}]`
    const levelNames = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL']
    const levelName = levelNames[entry.level]

    switch (entry.level) {
      case LogLevel.DEBUG:
        console.debug(prefix, entry.message, entry.data)
        break
      case LogLevel.INFO:
        console.info(prefix, entry.message, entry.data)
        break
      case LogLevel.WARN:
        console.warn(prefix, entry.message, entry.data)
        break
      case LogLevel.ERROR:
      case LogLevel.FATAL:
        console.error(prefix, entry.message, entry.data)
        if (entry.stack) {
          console.error(entry.stack)
        }
        break
    }
  }

  private saveLogs(): void {
    try {
      const recentLogs = this.logs.slice(-100)
      localStorage.setItem('app_logs', JSON.stringify(recentLogs))
    } catch (error) {
      console.error('[Logger] Failed to save logs:', error)
    }
  }

  debug(category: LogCategory, message: string, data?: any): void {
    this.log(LogLevel.DEBUG, category, message, data)
  }

  info(category: LogCategory, message: string, data?: any): void {
    this.log(LogLevel.INFO, category, message, data)
  }

  warn(category: LogCategory, message: string, data?: any): void {
    this.log(LogLevel.WARN, category, message, data)
  }

  error(category: LogCategory, message: string, data?: any, stack?: string): void {
    this.log(LogLevel.ERROR, category, message, data, stack)
  }

  fatal(category: LogCategory, message: string, data?: any, stack?: string): void {
    this.log(LogLevel.FATAL, category, message, data, stack)
  }

  getLogs(category?: LogCategory, level?: LogLevel): LogEntry[] {
    let filtered = this.logs

    if (category) {
      filtered = filtered.filter(log => log.category === category)
    }

    if (level !== undefined) {
      filtered = filtered.filter(log => log.level >= level)
    }

    return filtered
  }

  clearLogs(): void {
    this.logs = []
    localStorage.removeItem('app_logs')
    this.info(LogCategory.STORAGE, 'Logs cleared')
  }

  exportLogs(): string {
    return JSON.stringify(this.logs, null, 2)
  }

  setMinLevel(level: LogLevel): void {
    this.minLevel = level
    this.saveSettings()
  }

  setEnableConsole(enabled: boolean): void {
    this.enableConsole = enabled
    this.saveSettings()
  }

  setEnableStorage(enabled: boolean): void {
    this.enableStorage = enabled
    this.saveSettings()
  }
}

export const logger = Logger.getInstance()
export default logger
