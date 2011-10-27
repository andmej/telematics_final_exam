#encoding: utf-8
class Student
  XML_BUILDER_OPTIONS = { :root => "ei", :skip_types => true }
  
  def self.xml_for_students_on_course(current_teacher, course_id, group)
    unless current_teacher.has_access_to_course?(course_id)
      return { :curso => { :status => "error", :mensaje => "#{current_teacher.name} no es un profesor de este curso." } }.to_xml(XML_BUILDER_OPTIONS)            
    end
    
    unless group.present?
      return { :curso => { :status => "error", :mensaje => "No se especificó el parámetro 'group'." } }.to_xml(XML_BUILDER_OPTIONS)
    end
    
    students = read_hash.map { |c| c["estudiante"] if c["codigo"] == course_id and c["grupo"] == group }.compact.first
    students = [students] unless students.is_a?(Array)

    { :curso => { :codigo => course_id, :grupo => group, :estudiante => RootlessArray.new(students) } }.to_xml(XML_BUILDER_OPTIONS)
  end


  def self.xml_for_students_with_similar_name(current_teacher, name_pattern)
    unless name_pattern.present?
      return { :curso => { :status => "error", :mensaje => "No se especificó el parámetro 'name_pattern'." } }.to_xml(XML_BUILDER_OPTIONS.merge(:root => "ar"))
    end    
    
    students = Hash.from_xml(File.read(Rails.root.join("xml/ar/estudiantes.xml")))["ar"]["estudiante"]
    students = students.collect do |student|
      if current_teacher.has_access_to_student?(student["codigo"])
        { :codigo => student["codigo"], :nombre => student["nombre"] } if student["nombre"] =~ /.*#{name_pattern}.*/i
      end
    end.compact.uniq
    
    { :estudiante => RootlessArray.new(students) }.to_xml(XML_BUILDER_OPTIONS.merge(:root => "ar"))
  end

  def self.xml_for_single_student(current_teacher, student_id)
    unless current_teacher.has_access_to_student?(student_id)
      return { :curso => { :status => "error", :mensaje => "#{current_teacher.name} no tiene acceso a este estudiante." } }.to_xml(XML_BUILDER_OPTIONS.merge(:root => "ar"))
    end

    students = Hash.from_xml(File.read(Rails.root.join("xml/ar/estudiantes.xml")))["ar"]["estudiante"]
    student = students.select { |student| student_id == student["codigo"] }.first
    puts student.inspect
    student["cursos"] = (student.delete("cursos") || {"curso" => [] })["curso"]
    { :estudiante => student }.to_xml(XML_BUILDER_OPTIONS.merge(:root => "ar"))    
  end


  private
  
  def self.read_hash
    hash = Hash.from_xml(File.read(Rails.root.join("xml/ei/listaclase.xml")))["ei"]["curso"]
  end
end