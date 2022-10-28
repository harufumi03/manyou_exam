50.times do |i|
  Task.create!(title: "Task#{i+1}", content: "study Programming")
end