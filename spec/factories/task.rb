# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを作成されます
  factory :task do
    title { 'first_task' }
    content { 'sample1' }
    created_at {'2022-12-25'}
    deadline_on {'2025-02-18'}
    priority {'中'}
    status {'未着手'}
    user_id {'1'}
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名をつける場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要がります
  factory :second_task, class: Task do
    title { 'second_task' }
    content { '顧客へ営業のメールを送る' }
    created_at {'2022-12-24'}
    deadline_on {'2025-02-17'}
    priority {'高'}
    status {'着手中'}
    user_id {'2'}
  end

  factory :third_task, class: Task do
    title { 'third_task' }
    content { 'keepの記入をする' }
    created_at {'2022-12-23'}
    deadline_on {'2025-02-16'}
    priority {'低'}
    status {'完了'}
    user_id {'3'}
  end

  factory :sample_task, class: Task do
    title { 'sample_task' }
    content { 'keepの記入をする' }
    deadline_on {'2025-02-16'}
  end
end