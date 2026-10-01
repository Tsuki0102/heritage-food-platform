import { defineStore } from 'pinia'

// 测试问题类型
export interface Question {
  id: number
  text: string
  options: Option[]
}

export interface Option {
  id: string
  text: string
  value: string
}

// 测试结果类型
export interface TasteResult {
  sweet: number
  spicy: number
  light: number
  sour: number
  region: string[]
  portrait: string
  recommendedFoods: string[]
  completed: boolean
}

// 推荐美食数据
const FOOD_RECOMMENDATIONS = {
  sweet: ["江南糕点", "广式糖水", "苏式月饼"],
  spicy: ["川菜火锅", "湖南剁椒鱼头", "贵州酸汤鱼"],
  light: ["粤菜清蒸鱼", "淮扬菜狮子头", "杭帮菜西湖醋鱼"],
  sour: ["山西老陈醋", "贵州酸汤", "东北酸菜"]
}

// 地域美食推荐
const REGION_FOODS = {
  sichuan: ["麻婆豆腐", "水煮鱼", "回锅肉"],
  guangdong: ["白切鸡", "烧鹅", "虾饺"],
  shandong: ["九转大肠", "糖醋鲤鱼", "葱烧海参"],
  jiangsu: ["松鼠桂鱼", "叫花鸡", "盐水鸭"]
}

// 口味画像
const TASTE_PORTRAITS = [
  "江南清鲜爱好者",
  "川蜀麻辣达人",
  "粤式精致品味",
  "鲁菜传统守护者",
  "酸甜开胃达人",
  "均衡饮食倡导者"
]

interface TasteTestState {
  questions: Question[]
  answers: Record<number, string>
  result: TasteResult
  currentQuestion: number
  isCompleted: boolean
}

export const useTasteTestStore = defineStore('tasteTest', {
  state: (): TasteTestState => ({
    questions: [
      {
        id: 1,
        text: "你更喜欢哪种口味？",
        options: [
          { id: "sweet", text: "甜", value: "sweet" },
          { id: "spicy", text: "辣", value: "spicy" },
          { id: "light", text: "清淡", value: "light" },
          { id: "sour", text: "酸", value: "sour" }
        ]
      },
      {
        id: 2,
        text: "你对辣味的接受程度？",
        options: [
          { id: "none", text: "完全不吃辣", value: "none" },
          { id: "mild", text: "微辣", value: "mild" },
          { id: "medium", text: "中等辣度", value: "medium" },
          { id: "hot", text: "重辣", value: "hot" }
        ]
      },
      {
        id: 3,
        text: "你更倾向于哪个地域的美食？",
        options: [
          { id: "sichuan", text: "川菜", value: "sichuan" },
          { id: "guangdong", text: "粤菜", value: "guangdong" },
          { id: "shandong", text: "鲁菜", value: "shandong" },
          { id: "jiangsu", text: "苏菜", value: "jiangsu" }
        ]
      },
      {
        id: 4,
        text: "你更喜欢什么烹饪方式？",
        options: [
          { id: "steamed", text: "清蒸", value: "steamed" },
          { id: "braised", text: "红烧", value: "braised" },
          { id: "stir-fried", text: "爆炒", value: "stir-fried" },
          { id: "stewed", text: "炖煮", value: "stewed" }
        ]
      },
      {
        id: 5,
        text: "你用餐时更看重什么？",
        options: [
          { id: "taste", text: "味道", value: "taste" },
          { id: "health", text: "健康", value: "health" },
          { id: "appearance", text: "颜值", value: "appearance" },
          { id: "price", text: "性价比", value: "price" }
        ]
      }
    ],
    answers: {},
    result: {
      sweet: 0,
      spicy: 0,
      light: 0,
      sour: 0,
      region: [],
      portrait: "",
      recommendedFoods: [],
      completed: false
    },
    currentQuestion: 0,
    isCompleted: false
  }),
  actions: {
    // 选择答案
    selectAnswer(questionId: number, optionValue: string) {
      this.answers[questionId] = optionValue
      
      // 如果是最后一题，生成结果
      if (questionId === this.questions.length) {
        this.generateResult()
        this.isCompleted = true
        this.saveResult()
      } else {
        // 否则进入下一题
        this.currentQuestion++
      }
    },
    
    // 生成测试结果
    generateResult() {
      // 重置结果
      this.result = {
        sweet: 0,
        spicy: 0,
        light: 0,
        sour: 0,
        region: [],
        portrait: "",
        recommendedFoods: [],
        completed: true
      }
      
      // 分析答案
      for (const [questionId, answer] of Object.entries(this.answers)) {
        const qId = parseInt(questionId)
        
        if (qId === 1) {
          // 第一题：口味偏好
          switch (answer) {
            case "sweet":
              this.result.sweet = 10
              break
            case "spicy":
              this.result.spicy = 10
              break
            case "light":
              this.result.light = 10
              break
            case "sour":
              this.result.sour = 10
              break
          }
        } else if (qId === 2) {
          // 第二题：辣度接受程度
          switch (answer) {
            case "none":
              this.result.spicy = 0
              this.result.light = 5
              break
            case "mild":
              this.result.spicy = 3
              break
            case "medium":
              this.result.spicy = 7
              break
            case "hot":
              this.result.spicy = 10
              break
          }
        } else if (qId === 3) {
          // 第三题：地域偏好
          this.result.region.push(answer)
        } else if (qId === 4) {
          // 第四题：烹饪方式偏好
          switch (answer) {
            case "steamed":
              this.result.light += 5
              break
            case "braised":
              this.result.sweet += 3
              break
            case "stir-fried":
              this.result.spicy += 3
              break
            case "stewed":
              this.result.sour += 3
              this.result.light += 2
              break
          }
        } else if (qId === 5) {
          // 第五题：用餐看重因素
          switch (answer) {
            case "health":
              this.result.light += 5
              break
            case "appearance":
              this.result.sweet += 2
              this.result.light += 2
              break
            case "taste":
              this.result.spicy += 2
              this.result.sweet += 2
              break
            case "price":
              this.result.sour += 3
              break
          }
        }
      }
      
      // 生成口味画像
      this.generatePortrait()
      
      // 生成推荐美食
      this.generateRecommendations()
    },
    
    // 生成口味画像
    generatePortrait() {
      const scores = [
        { type: "sweet", score: this.result.sweet },
        { type: "spicy", score: this.result.spicy },
        { type: "light", score: this.result.light },
        { type: "sour", score: this.result.sour }
      ]
      
      scores.sort((a, b) => b.score - a.score)
      const topTaste = scores[0].type
      
      // 根据最高分数和地域偏好生成画像
      if (this.result.region.includes("jiangsu") || this.result.light > 5) {
        this.result.portrait = "江南清鲜爱好者"
      } else if (this.result.region.includes("sichuan") || this.result.spicy > 7) {
        this.result.portrait = "川蜀麻辣达人"
      } else if (this.result.region.includes("guangdong")) {
        this.result.portrait = "粤式精致品味"
      } else if (this.result.region.includes("shandong")) {
        this.result.portrait = "鲁菜传统守护者"
      } else if (this.result.sour > 5) {
        this.result.portrait = "酸甜开胃达人"
      } else {
        this.result.portrait = "均衡饮食倡导者"
      }
    },
    
    // 生成推荐美食
    generateRecommendations() {
      const recommendations = new Set<string>()
      
      // 根据口味偏好推荐
      if (this.result.sweet > 5) {
        FOOD_RECOMMENDATIONS.sweet.forEach(food => recommendations.add(food))
      }
      if (this.result.spicy > 5) {
        FOOD_RECOMMENDATIONS.spicy.forEach(food => recommendations.add(food))
      }
      if (this.result.light > 5) {
        FOOD_RECOMMENDATIONS.light.forEach(food => recommendations.add(food))
      }
      if (this.result.sour > 5) {
        FOOD_RECOMMENDATIONS.sour.forEach(food => recommendations.add(food))
      }
      
      // 根据地域偏好推荐
      this.result.region.forEach(region => {
        if (REGION_FOODS[region as keyof typeof REGION_FOODS]) {
          REGION_FOODS[region as keyof typeof REGION_FOODS].forEach(food => recommendations.add(food))
        }
      })
      
      this.result.recommendedFoods = Array.from(recommendations).slice(0, 6)
    },
    
    // 保存结果到本地缓存
    saveResult() {
      localStorage.setItem('tasteTestResult', JSON.stringify(this.result))
    },
    
    // 从本地缓存加载结果
    loadResult() {
      const savedResult = localStorage.getItem('tasteTestResult')
      if (savedResult) {
        this.result = JSON.parse(savedResult)
        this.isCompleted = this.result.completed
      }
    },
    
    // 重新测试
    resetTest() {
      this.answers = {}
      this.result = {
        sweet: 0,
        spicy: 0,
        light: 0,
        sour: 0,
        region: [],
        portrait: "",
        recommendedFoods: [],
        completed: false
      }
      this.currentQuestion = 0
      this.isCompleted = false
      localStorage.removeItem('tasteTestResult')
    },
    
    // 获取当前问题
    getCurrentQuestion() {
      return this.questions[this.currentQuestion]
    },
    
    // 检查是否所有问题都已回答
    isAllQuestionsAnswered() {
      return Object.keys(this.answers).length === this.questions.length
    }
  }
})
