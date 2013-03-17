describe 'String contains', ->
	it 'returns true when a string contains a substring', ->
		s = 'abra'
		t = 'kadabra'
		expect(t.contains(s)).toEqual(true)
	it 'returns false when a string doesnt contain a substring', ->
		s = 'abra'
		t = 'xyz'
		expect(t.contains(s)).toEqual(false)
	it 'returns false if the lead string is empty', ->
		s = ''
		t = 'abra'
		expect(s.contains(t)).toEqual(false)
	it 'returns true if the substring is ever empty', ->
		s = ''
		t = 'abra'
		expect(t.contains(s)).toEqual(true)
		t = ''
		expect(t.contains(s)).toEqual(true)