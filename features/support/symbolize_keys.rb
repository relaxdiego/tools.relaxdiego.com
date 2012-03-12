class Hash
  def symbolize_keys
    self.keys.each do |key|
      self[key.downcase.gsub(' ', '_').to_sym] = self[key]
      self.delete(key)
    end
    self
  end
end