=begin
Copyright 2016 SourceClear Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

require_relative 'expression_rule'
require 'git_diff_parser'

class RuleAuditor
  # The actual content of the line is not publicly exposed.
  GitDiffParser::Line.class_eval { attr_reader :content }

  def initialize(all_rules)
    # Used for expression rules so it doesn't have to look them up
    @all_rules = all_rules
  end

  def audit(commit, rule_type_id, rule_value, diff, rule_value_2='')
    case rule_type_id
    when 1
      return unless diff
      audit_filename_pattern(Regexp.new(rule_value), diff)
    when 2
      return unless diff
      audit_changed_code_pattern(Regexp.new(rule_value), diff)
    when 3
      return unless diff
      audit_code_pattern(Regexp.new(rule_value), diff)
    when 4
      audit_message_pattern(commit, Regexp.new(rule_value))
    when 5
      audit_author_pattern(commit, Regexp.new(rule_value))
    when 6
      audit_commit_pattern(commit, Regexp.new(rule_value), diff)
    when 7
      audit_expression(commit, rule_value, diff)
    when 8
      audit_specific_file_changes_pattern(Regexp.new(rule_value), Regexp.new(rule_value_2), diff)
    end
  end

private

  def audit_filename_pattern(pattern, diff)
    filenames = diff.collect { |e| e.file }
    results = filenames.select { |e| e =~ pattern }
    results.empty? ? nil : results
  end

  def audit_changed_code_pattern(pattern, diff)
    results = []
    diff.each do |d|
      matches = d.body.scan(pattern)
      next if matches.empty?

      changed_lines = d.changed_lines.collect { |e| e.content }
      changed_ranges = []
      index_offset = 0
      changed_lines.each do |line|
        start = d.body.index(line, index_offset)
        stop = start + line.length
        index_offset = stop
        changed_ranges << [start, stop]
      end
      next if changed_lines.empty?

      index_offset = 0
      found = []
      matches.each do |match|
        # Match could be an array if regex had groups
        match = match.join if match.is_a?(Array)
        start_offset = d.body.index(match, index_offset)
        end_offset = start_offset + match.length
        index_offset = end_offset

        changed_ranges.each do |(change_start, change_end)|
          next if start_offset >= change_end
          next if end_offset <= change_start

          frame_start_offset = [start_offset - 200, 0].max
          frame_end_offset = [end_offset + 200, d.body.size].min
          found << d.body[frame_start_offset..frame_end_offset]
        end
      end
      next if found.empty?

      found.each do |f|
        results << {
          file: d.file,
          body: f,
        }
      end
    end
    results.empty? ? nil : results
  end

  def audit_code_pattern(pattern, diff)
    results = []
    diff.each do |d|
      matches = d.body.scan(pattern)
      next if matches.empty?

      index_offset = 0
      found = []
      matches.each do |match|
        # Match could be an array if regex had groups
        match = match.join if match.is_a?(Array)
        start_offset = d.body.index(match, index_offset)
        end_offset = start_offset + match.length
        index_offset = end_offset

        frame_start_offset = [start_offset - 200, 0].max
        frame_end_offset = [end_offset + 200, d.body.size].min
        found << d.body[frame_start_offset..frame_end_offset]
      end

      found.each do |f|
        results << {
          file: d.file,
          body: f,
        }
      end
    end
    results.empty? ? nil : results
  end

  def audit_message_pattern(commit, pattern)
    message = commit[:commit][:message]
    (message =~ pattern) ? message : nil
  end

  def audit_author_pattern(commit, pattern)
    author_name = commit[:commit][:author][:name]
    author_email = commit[:commit][:author][:email]
    author = "#{author_name} <#{author_email}>"
    (author =~ pattern) ? author : nil
  end

  def audit_expression(commit, expression, diff)
    rule = ExpressionRule.new(expression, @all_rules)
    rule.evaluate(commit, diff)
  end

  def audit_commit_pattern(commit, pattern, diff)
    results = []
    results << audit_message_pattern(commit, pattern)
    results << audit_code_pattern(pattern, diff) if diff
    results.compact!
    results.empty? ? nil : results
  end

  def audit_specific_file_changes_pattern(pattern, filename, diff)
    results = []
    return results if filename.blank? || diff.blank?
    diff.each do |d|
      next if d.file.empty? || (d.file =~ filename).blank?
      next if d.body.empty? || (d.body =~ pattern).blank?
      results << {
          file: d.file,
          body: d.body,
      }
    end
    results.empty? ? nil : results
  end
end
