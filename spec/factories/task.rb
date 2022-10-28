# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように実際に存在するクラス名と一致するテストデータの名前をつければ、そのクラスのテストデータを作成されます
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する' }
    created_at {'2022-12-25'}
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名をつける場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要がります
  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る' }
    created_at {'2022-12-24'}
  end

  factory :third_task, class: Task do
    title { 'KPT記述' }
    content { 'keepの記入をする' }
    created_at {'2022-12-23'}
  end
end