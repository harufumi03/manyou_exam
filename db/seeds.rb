10.times do |i|
  Task.create!(title: "first_task", content: "勉強する", deadline_on: "2025-02-18", priority: 1, status: 0)
end

10.times do |i|
  Task.create!(title: "second_task", content: "課題を提出する", deadline_on: "2025-02-17", priority: 2, status: 1)
end

10.times do |i|
  Task.create!(title: "third_task", content: "休養する", deadline_on: "2025-02-16", priority: 0, status: 2)
end