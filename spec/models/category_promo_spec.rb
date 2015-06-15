describe CategoryPromo do
  it 'associations' do
    expect(subject).to belong_to(:category)
  end
end
