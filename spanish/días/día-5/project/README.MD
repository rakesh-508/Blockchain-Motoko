# The Verifier 👨‍🏫
## Introduction
Imagine that you are an now an instructor at [Motoko School](https://twitter.com/MotokoSchool), where you are currently overseeing a cohort of more than 200 dedicated students!  🤯 <br/>
As part of the program, you have assigned these ambitious learners to tackle 4 distinct projects, each designed to challenge their skills and knowledge. Upon completion, it falls on your shoulders to meticulously review and evaluate their work, ultimately determining whether they have met the criteria for [graduation](../../../README.MD#🎓-graduation). <br/>
Fortunately, as an adept Motoko developer yourself, you possess the expertise and confidence to streamline this verification process by leveraging automation. This innovative approach will not only save you valuable time but also pave the way for the future of **Motoko Bootcamp**. Let's get started!
## 🧑‍🏫 Requirements 
Your task is to create the code for a **instructor**, which is implemented as a canister. The idea is for the student to input his canister id and get automatically verified by the canister. If the canister id submitted fulfill the requirements then the students will automatically graduate; just imagine the hours of work you will save! <br/>

[ADD ILLUSTRATION]

> For the purpose of this Bootcamp, we will not attempt to build a verifier that test all 4 previous projects. We will only attempts to verify a simple version of the calculator you've implemented during Day 1. The code for this simple calculator has already been implemented, and can be found [here](../project/calculator/main.mo).

## Part 1: Storing the students information.
The idea in this section is to build the code for storing informations about students. 
### Step-by-step
A student profile is defined as follows:
```motoko
public type StudentProfile = {
    name : Text;
    Team : Text;
    graduate : Bool;
};
```
1. Define a variable named `studentProfileStore`, which is a `HashMap` for storing student profile. The keys in this wall are of type `Principal` and represent the identity of students, while the values are of type `StudentProfile`. 
2. Implement the `addMyProfile` function which accepts a `profile` of type `StudentProfile` and adds it into the `studentProfileStore`. This function assumes that the `caller` is the student corresponding to the profile.
```motoko
addMyProfile: shared (profile : StudentProfile) -> async Result.Result<(), Text>;
```
3. Implement the `seeAProfile` query function, which accepts a principal `p` of type `Principal` and returns the optional corresponding student profile.
```motoko
seeAProfile : query (p : Principal) -> async ?StudentProfile;
```
4. Implement the `updateMyProfile` function which allows a student to perform a modification on its student profile. If everything works, and the profile is updated the function should return a simple unit value wrapped in an `Ok` result. If the `caller` doesn't have a student profile the function should return an error message wrapped in an `Err` result. 
```motoko
updateMyProfile : shared (profile : StudentProfile) -> async Result.Result<(), Text>;
```
5. Implement the `deleteMyProfile` function which allows a student to delete its student profile. If everything works, and the profile is deleted the function should return a simple unit value wrapped in an `Ok` result. If the `caller` doesn't have a student profile the function should return an error message wrapped in an `Err` result. 
```motoko
deleteMyProfile : shared (profile : StudentProfile) -> async Result.Result<(), Text>;
```
6. Make sure that `studentProfileStore` is resistant to upgrades, which means that all student profiles will be preserved even if the canister undergoes an upgrade. Implement this by utilizing the `pre_upgrade` and `post_upgrade` hooks.
## Part 2: Testing of the simple calculator.
The idea in this section is to implement the code that perfoms the test on the simple calculator.
We are going to test: 
- The `reset` function.
- The `add` function.
- The `sub` function.

If those 3 functions are correctly implemented, then the test is positive and the canister is validated.

### Step-by-step
The type `TestResult` is defined as follows:
```motoko
    public type TestResult = Result.Result<(), TestError>;
    public type TestError = {
        #UnexpectedValue : Text;
        #UnexpectedError : Text;
    };
```

1. Implement the `test` function that takes a `canisterId` of type `Principal` and returns the result of the test of type `TestResult`. Make sure to distringuish between the two types of erros.
- UnexpectedValue should be returned whenever the calculator returns a wrong value. For instance, if a call to `reset` followed by `add(1)` returns 2.
- UnexpectedError should be returned for all other types of errors. For instance, if the function `add` is not even implemented as part of the canister's interface.
```motoko
test: shared (canisterId : Principal) -> async TestResult;
```

## Part 3: Verifying the controller of the calculator.
In this section we want to make sure that the owner of the verified canister is actually the student that registered it. Otherwise, a student could use the canister of another one.
### Step-by-step
1. Implement the `verifyOwnership` function that takes a `canisterId` of type `Principal` and a `principalId` of type `Principal` and returns a boolean indicating if the `principalId` is among the controllers of the canister corresponding to the `canisterId` provided.

> Unfortunately, as of today, the `canister_status` method of the management canister can only be used when the canister calling it is also one of the controller of the canister you are trying to check the status. [Read the dedicated topic for more information](https://forum.dfinity.org/t/how-to-find-out-the-controllers-of-a-canister/14345/3). 

## Part 4: Graduation! 
In this sections the idea is to let students submit their work and automatically verify the canister. If the tests are passed then the `graduation` field of the student is automatically changed.
1. Implement the `verifyWork` function that takes a `canisterId` of type `Principal` and perfoms the necessary verifications on the canister. If all the criteria for graduations are validated; then the `graduation` field is updated accordingly.
## Part 5: List of graduates 🎓
In this section the idea is to implement a function to handle HTTP requests within the verifier canister. Anyone should be able to go to 

1. Create a an `Array` called `graduates` that stores the name of graduates.
2. Implement a timer so that the array is updated every hour.
3. Implement the `http_request` method.


## 📺 Interface
> At the end of the project your canister should implement the following interface:
```motoko
actor Verifier {

};
```

