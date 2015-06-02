class CreateTestData

  constructor: ()->
    @.modules = []
    @.lessons = []
    @.curriculums = []
    @.title = 'Test Curriculum'
    @.lessonTitles = ['lesson1title', 'lesson2title']
    console.log @
  
  setUp: ()->

    id1 = Modules.insert {
      'type':'MULTIPLE_CHOICE',
      'image':'NooraHealthContent/Image/actgoalsO1Q2.png',
      'options': [
        'NooraHealthContent/Image/actgoalsO1Q3.png',
        'NooraHealthContent/Image/actgoalsO3Q1.png',
        'NooraHealthContent/Image/actgoalsO3Q2.png',
        'NooraHealthContent/Image/actgoalsO3Q3.png',
        'NooraHealthContent/Image/actgoalsO4Q1.png',
        'NooraHealthContent/Image/actgoalsO4Q2.png'
      ],
      'audio': 'NooraHealthContent/Image/actgoalsO4Q3.png',
      'correct_audio':'NooraHealthContent/Image/actgoalsO5Q1.png',
      'incorrect_audio':'NooraHealthContent/Image/actgoalsO5Q2.png'
    }

    id2 = Modules.insert {
      'type':'SLIDE',
      'image':'NooraHealthContent/Image/actgoalsO5Q3.png',
      'audio':'NooraHealthContent/Image/actgoalsO6Q1.png'
    }

    lessonId1 = Lessons.insert {
      'title': @.lessonTitles[0],
      'image':'NooraHealthContent/Image/actgoalsO1Q1.png',
      'modules':[id1, id2]
    }

    id3 = Modules.insert {
      'type':'VIDEO',
      'video':'NooraHealthContent/Image/actgoalsO6Q2.png'
    }

    id4 = Modules.insert {
      'type':'BINARY',
      'options':[ 'NO', 'YES'],
      'image':'NooraHealthContent/Image/actgoalsO6Q3.png'
    }

    lessonId2 = Lessons.insert {
      'title':'testlesson2',
      'image':'NooraHealthContent/Image/actgoalsO2Q2.png',
      'modules':[id3, id4]
    }

    curriculumId1 = Curriculum.insert {
      'title':@.title,
      'condition':'Testing Condition',
      'lessons':['testlesson1', 'testlesson2'],
    }

    @.modules = [id1, id2, id3, id4]
    @.lessons = [lessonId1, lessonId2]
    @.curriculums = [curriculumId1]

  curriculumTitle: ()->
    return @.title

  lessonId: (i)->
    return @.lessons[i]

  tearDown: ()->
    console.log "Tearing down the test data"
    for id in @.modules
      Modules.remove {_id: id}

    for id in @.lessons
      Lessons.remove {_id:id}

    for id in @curriculums
      Curriculum.remove {title: @.title}

