function burgularSimple()

    burgular,earthquake,alarm,radio = 1,2,3,4 #variables

    yes,no=1,2 #states 

    #useful for printing reaults 
    dictVariable=Dict{Integer,DiscreteVariable}()
    dictVariable[burglar]=DiscreteVariable("burglar",["yes","no"])
    dictVariable[earthquake]=DiscreteVariable("earthquake",["yes","no"])
    dictVariable[alarm]=DiscreteVariable("alarm",["yes","no"])
    dictVariable[radio]=DiscreteVariable("radio",["yes","no"])

    #dicrete probability tables:
    potBurglar=PotArray(burgular,[0.01 0.99])
    potEarthquake=PotArray(earthquake,[0.000001 , 1-0.000001])

    table = zeros(2,2)
    table[yes,yes]=1
    table[no,no]=0
    table[yes,no]=0
    table[no,no]=1
    potRadio=PotArray([radio earthquake],table)

    table=zeros(2,2,2)
    table[yes,yes,yes]=0.9999
    table[yes,yes,no]=0.99
    table[yes,no,yes]=0.99
    table[yes,no,no]=0.0001

    table[no,:,:] = 1-table[yes,:,:]
    potAlarm=PotArray([radio burgular earthquake], table)

    jointPot=prod([potBurglar potRadio potAlarm potEarthquake])

    println("p(burglar|alarm=yes):")
    show(condpot(setpot(jointpot,alarm,yes),burglar),dictVariable)
end