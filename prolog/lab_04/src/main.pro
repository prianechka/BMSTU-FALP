domains
  sex = symbol
  name = string
  person = person(sex, name)
  
predicates
  nondeterm parent(person, person)
  nondeterm grandparent(person, sex, name)
  
clauses
  grandparent(person(FindSex, GpName), ParentSex, Name) :- parent(person(FindSex, GpName), person(ParentSex, ParentName)),
                         parent(person(ParentSex, ParentName), person(_, Name)).

  parent(person(f, "Natalia"), person(m, "Sasha")).
  parent(person(m, "Nikolay"), person(m, "Sasha")).
  
  parent(person(m, "Yuri"), person(f, "Natalia")).
  parent(person(f, "Nadezhda"), person(f, "Natalia")).
  
  parent(person(m, "Alexander"), person(m, "Nikolay")).
  parent(person(f, "Lyubov"), person(m, "Nikolay")).
  
  parent(person(f, "Natalia"), person(f, "Zhenya")).
  parent(person(m, "Sergey"), person(f, "Zhenya")).

goal
  % 1. grandparent(person(f, GpName), _, "Sasha").
  % 2. grandparent(person(m, GpName), _, "Sasha").
  % 3. grandparent(person(_, GpName), _, "Sasha").
  % 4. grandparent(person(f, GpName), f, "Sasha").
  grandparent(person(_, GpName), f, "Sasha").