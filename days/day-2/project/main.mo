
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Text "mo:base/Text";
actor HomeWorkDiary {
    public type Homework = {
        title : Text;
        description : Text;
        dueDate : Time.Time;
        completed : Bool;
    };

    type Buffer<Homework> = Buffer.Buffer<Homework>;

    let homeworkDiary : Buffer<Homework> = Buffer.Buffer<Homework>(10);

    // Add a new homework task
    public func addHomework(homework : Homework) : async Nat {
        homeworkDiary.add(homework);
        homeworkDiary.size() - 1;
    };

    // Get a specific homework task by id
    public func getHomework(homeworkId : Nat) : async Result.Result<Homework, Text> {
        if (homeworkId <= homeworkDiary.size()) {
            #ok(homeworkDiary.get(homeworkId));
        } else {
            #err "id not found";
        };

    };

    // Update a homework task's title, description, and/or due date
    public func updateHomework(homeworkId : Nat, homework : Homework) : async Result.Result<(), Text> {
        if (homeworkId <= homeworkDiary.size()) {
            homeworkDiary.put(homeworkId, homework);
            #ok();
        } else {
            #err "id not found";
        };

    };

    // Mark a homework task as completed
    public func markAsCompleted(homeworkId : Nat) : async Result.Result<(), Text> {

        let homework = homeworkDiary.get(homeworkId);
        let newHomework = {
            title = homework.title;
            description = homework.description;
            dueDate = homework.dueDate;
            completed = true;
        };

        if (homeworkId <= homeworkDiary.size()) {
            #ok(homeworkDiary.put(homeworkId, newHomework));
        } else {
            #err "id not found";
        };
    };

    // Delete a homework task by id
    public func deleteHomework(homeworkId : Nat) : async Result.Result<(), Text> {
        if (homeworkId <= homeworkDiary.size()) {
            ignore homeworkDiary.remove(homeworkId);
            #ok();
        } else {
            #err "id not found";
        };

    };

    // Get the list of all homework tasks
    public query func getAllHomework() : async [Homework] {
        Buffer.toArray(homeworkDiary);
    };

    // Get the list of pending (not completed) homework tasks
    public query func getPendingHomework() : async [Homework] {
        let pendingWork : Buffer<Homework> = Buffer.Buffer<Homework>(10);
        for (homework in homeworkDiary.vals()) {
            if (homework.completed == false) {
                pendingWork.add(homework);
            };
        };
        Buffer.toArray(pendingWork);

    };

    // Search for homework tasks based on a search terms
    public query func searchHomework(searchTerm : Text) : async [Homework] {
        let homeWork : Buffer<Homework> = Buffer.Buffer<Homework>(10);
        let pattern : Text.Pattern = #text searchTerm;
        for (homework in homeworkDiary.vals()) {
            if ((homework.title == searchTerm) or (Text.contains(homework.description, pattern))) {
                homeWork.add(homework);
            };
        };
        Buffer.toArray(homeWork);

    };

};