parent(person("f", "Tatiana"), person("m", "Alexander")).
parent(person("m", "Dmitry"), person("m", "Alexander")).

parent(person("f", "Alena"), person("m", "Dmitry")).
parent(person("m", "Nebozhena"), person("m", "Dmitry")).

parent(person("f", "Natalia"), person("m", "Nebozhena")).

parent(person("f", "Ekaterina"), person("f", "Natalia")).
parent(person("m", "Pier"), person("f", "Natalia")).

parent(person("f", "Antonina"), person("m", "Pier")).
parent(person("f", "Antonina"), person("f", "Adelina")).

parent(person("f", "Natalia"), person("f", "Katarina")).
parent(person("f", "Katarina"), person("m", "Miron")).
parent(person("m", "Miron"), person("f", "Silviya")).

parent(person("f", "Ember"), person("f", "Alena")).
parent(person("m", "Nikolay"), person("f", "Alena")).

parent(person("f", "Anastasia"), person("m", "Nikolay")).
parent(person("m", "Ivan"), person("m", "Nikolay")).


parent(person("f", "Regina"), person("f", "Tatiana")).
parent(person("m", "Rostislav"), person("f", "Tatiana")).

parent(person("f", "Olga"), person("m", "Rostislav")).
parent(person("m", "Ashot"), person("m", "Rostislav")).

parent(person("f", "Ekaterina"), person("m", "Ashot")).
parent(person("m", "Alexandro"), person("m", "Ashot")).

parent(person("f", "Nastya"), person("f", "Olga")).
parent(person("m", "Alessandro"), person("f", "Olga")).

parent(person("f", "Sophya"), person("f", "Regina")).
parent(person("m", "Ivan"), person("f", "Regina")).

parent(person("f", "Anarchy"), person("m", "Eric")).
parent(person("m", "Stakan Portveina"), person("m", "Eric")).

parent(person("m", "Eric"), person("f", "Russian democracy")).

godMother(person("f", "Tamara"), person("m", "Alexander")).
godFather(person("m", "Nikita"), person("m", "Alexander")).

grandparent(person(FindSex, GpName), ParentSex, Name) :-
			  parent(person(FindSex, GpName), person(ParentSex, ParentName)),
                         parent(person(ParentSex, ParentName), person(_, Name)).
                         
% Defend
grandGrandMother(person("f", GGMName), ParentSex, Name) :- 
				parent(person("f", GGMName), person(GrandSex, GpName)),
				parent(person(GrandSex, GpName), person(ParentSex, ParentName)),
                         	parent(person(ParentSex, ParentName), person(_, Name)).

grandGrandFather(person("m", GGMName), ParentSex, Name) :- 
				parent(person("m", GGMName), person(GrandSex, GpName)),
				parent(person(GrandSex, GpName), person(ParentSex, ParentName)),
                         	parent(person(ParentSex, ParentName), person(_, Name)).
                         	
grandGrandGrandMother(person("f", GGGMName), ParentSex, Name) :- 
				parent(person("f", GGGMName), person(Sex, GGMName)),
				parent(person(Sex, GGMName), person(GrandSex, GpName)),
				parent(person(GrandSex, GpName), person(ParentSex, ParentName)),
                         	parent(person(ParentSex, ParentName), person(_, Name)).

grandGrandGrandFather(person("m", GGGMName), ParentSex, Name) :- 
				parent(person("m", GGGMName), person(Sex, GGMName)),
				parent(person(Sex, GGMName), person(GrandSex, GpName)),
				parent(person(GrandSex, GpName), person(ParentSex, ParentName)),
                         	parent(person(ParentSex, ParentName), person(_, Name)).
                         	
fatherOfRussiaDemocratic(Name, FindSex) :- parent(person(FindSex, Name), person("f", "Russian democracy")).

anarchySon(Name, FindSex) :- parent(person("f", "Anarchy"), person(FindSex, Name)).

grandGrandGrandGrandMother(person("f", LastName), ParentSex, Name) :- 
				parent(person("f", LastName), person(GSex, GGGMName)),
				parent(person(GSex, GGGMName), person(Sex, GGMName)),
				parent(person(Sex, GGMName), person(GrandSex, GpName)),
				parent(person(GrandSex, GpName), person(ParentSex, ParentName)),
                         	parent(person(ParentSex, ParentName), person(_, Name)).

godFatherbyName(Name, FatherName) :-  godFather(person("m", FatherName), person(_, Name)).
godMotherbyName(Name, MotherName) :-  godMother(person("f", MotherName), person(_, Name)).

fourthSister(person("f", SisName), ParentSex, Name) :- 
				parent(person(ThirdSex, LastName), person("f", SisName)),
				parent(person(SecSex, NextName), person(ThirdSex, LastName)),
				parent(person(Grand2Sex, GGMName), person(SecSex, NextName)),
				parent(person(Grand2Sex, GGMName), person(GrandSex, GpName)),
				parent(person(GrandSex, GpName), person(ParentSex, ParentName)),
                         	parent(person(ParentSex, ParentName), person(_, Name)).
                         	
motherN(Name, TmpName, N, I) :- I = 1, parent(person("f", TmpName), person(_, Name)), !.
motherN(Name, TmpName, N, I) :- I =< N, I > 1, parent(person("f", TmpName), person("f", SecTmpName)), 
								I1 is I - 1, motherN(Name, SecTmpName, N, I1), !.

findMotherN(Name, MotherName, N) :- motherN(Name, MotherName, N, N).