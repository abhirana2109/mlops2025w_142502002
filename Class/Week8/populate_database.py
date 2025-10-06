import random
from faker import Faker
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure
import config

fake = Faker()

MAJORS = ["Computer Science", "Mechanical Engineering", "Psychology", "Biology", "Business Administration"]
MINORS = ["Mathematics", "Physics", "Creative Writing", "Economics", "History"]
COURSES = {
    "Computer Science": ["Intro to Python", "Data Structures", "Algorithms", "Database Systems", "Web Development"],
    "Mechanical Engineering": ["Thermodynamics", "Statics and Dynamics", "Fluid Mechanics", "Machine Design"],
    "Psychology": ["Intro to Psychology", "Cognitive Psychology", "Social Psychology", "Abnormal Psychology"],
    "Biology": ["General Biology", "Genetics", "Cell Biology", "Ecology"],
    "Business Administration": ["Principles of Management", "Marketing", "Corporate Finance", "Business Law"]
}

def create_student_record(reg_no):
    """Generates a single, realistic student document."""
    major = random.choice(MAJORS)
    minor = random.choice([m for m in MINORS if m != major])
    
    student = {
        "reg_no": f"2025{reg_no:04d}",
        "name": fake.name(),
        "age": random.randint(18, 25),
        "year": random.randint(1, 4),
        "major": major,
        "minor": minor,
        "courses": random.sample(COURSES[major], k=random.randint(2, 4))
    }
    return student

def main():
    """Connects to MongoDB and populates the students collection."""
    try:
        client = MongoClient(config.MONGO_URI)
        db = client[config.DATABASE_NAME]
        students_collection = db.students
        
        client.admin.command('ismaster')
        print("MongoDB connection successful.")

        students_collection.delete_many({})
        print("Cleared existing student records.")
        
        all_students = [create_student_record(i) for i in range(1, 101)]
        
        students_collection.insert_many(all_students)
        
        print(f"Successfully inserted {len(all_students)} student records into the '{config.DATABASE_NAME}' database.")

    except ConnectionFailure as e:
        print(f"Could not connect to MongoDB: {e}")
    finally:
        if 'client' in locals():
            client.close()

if __name__ == "__main__":
    main()