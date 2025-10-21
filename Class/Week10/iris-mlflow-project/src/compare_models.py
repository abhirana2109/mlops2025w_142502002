import mlflow
import pandas as pd
from mlflow.tracking import MlflowClient

def compare_experiment_runs():
    """
    Fetches all runs from a specific MLflow experiment,
    compiles them into a DataFrame, and prints a sorted comparison table.
    """
    client = MlflowClient()
    
    # Get the experiment by name
    try:
        experiment = client.get_experiment_by_name("Iris Classification Hyperparameter Tuning")
        if experiment is None:
            print("Experiment not found!")
            return None
    except Exception as e:
        print(f"Error fetching experiment: {e}")
        return None

    # Get all runs from the experiment, excluding the parent run
    runs = client.search_runs(
        experiment_ids=[experiment.experiment_id],
        filter_string="tags.mlflow.runName != 'Hyperparameter Tuning Session'"
    )

    # Compile run data into a list of dictionaries
    comparison_data = []
    for run in runs:
        run_data = {
            'run_id': run.info.run_id,
            'run_name': run.data.tags.get('mlflow.runName', 'Unknown'),
            'model_type': run.data.params.get('model_type', 'Unknown'),
            'test_accuracy': run.data.metrics.get('test_accuracy', 0),
            'test_f1_score': run.data.metrics.get('test_f1_score', 0),
            'status': run.info.status
        }
        comparison_data.append(run_data)
        
    if not comparison_data:
        print("No runs found in the experiment.")
        return None

    # Create and sort the DataFrame
    df = pd.DataFrame(comparison_data)
    df = df.sort_values('test_accuracy', ascending=False)
    
    print("=" * 80)
    print("               Model Comparison Results")
    print("=" * 80)
    print(df.to_string(index=False))
    print("=" * 80)

    return df

if __name__ == "__main__":
    compare_experiment_runs()