import json
import toml
import torch
import torchvision.models as models
from itertools import product
import os

print("\nQuestion 3 answers for a to e :-\n")

# Helper Functions

def load_configs():
    """Loads all configuration files."""
    with open('pipeline_config.json', 'r') as f:
            pipeline_config = json.load(f)
    with open('model_params.toml', 'r') as f:
        model_params = toml.load(f)
    with open('grid_search.json', 'r') as f:
        grid_search_config = json.load(f)
    return pipeline_config, model_params, grid_search_config
        

def simulate_pipeline_run(pipeline_config, model_params):
    """
    Simulates running the pipeline for each model specified in the JSON config,
    using parameters from the TOML config.
    """
    print("Pipeline Simulation: Running Inference for Pre-trained Models")
    print(f"Data Source: {pipeline_config['data_source']['path_train']}\n")

    for model_spec in pipeline_config['models_to_run']:
        arch_id = model_spec['architecture_id']
        params = model_params[arch_id]
        
        print(f"Loading Model: {model_spec['name']}")
        
        # a. implementing model inference using pre-trained ResNet
        print("a. implementing model inference using pre-trained ResNet")
        try:
            model_function = getattr(models, arch_id)
            model = model_function(weights='IMAGENET1K_V1' if model_spec['pretrained'] else None)
            model.eval() # Set model to evaluation mode
            print(f"Success: Instantiated pre-trained '{arch_id}' from PyTorch.")
            
            # Demonstrate a single forward pass with a dummy tensor
            dummy_input = torch.randn(1, 3, 224, 224)
            with torch.no_grad():
                output = model(dummy_input)
            print(f"Success: Performed a dummy inference pass. Output shape: {output.shape}")

        except Exception as e:
            print(f"Failure: Could not instantiate model '{arch_id}'. Error: {e}")
            continue

        # d. integrating b & c : Show the combined configuration
        print("d. integrating b & c : Show the combined configuration")
        print("Configuration used:")
        print(f"Architecture: {arch_id} (from pipeline_config.json)")
        print(f"Pretrained: {model_spec['pretrained']} (from pipeline_config.json)")
        print(f"Learning Rate: {params['learning_rate']} (from model_params.toml)")
        print(f"Batch Size: {params['batch_size']} (from model_params.toml)")
        print(f"Optimizer: {params['optimizer']} (from model_params.toml)\n")

def perform_hyperparameter_tuning(model_params, grid_search_config):
    """
    Lays out the plan for a grid search based on the grid_search.json file.
    """
    # e. performing hyperparameter tuning
    print("e. performing hyperparameter tuning")
    print("Hyperparameter Tuning Simulation (Grid Search)")

    arch_id = grid_search_config['target_architecture']
    base_params = model_params[arch_id]
    search_space = grid_search_config['search_space']

    print(f"Target Architecture for Tuning: {arch_id}")
    print(f"Base Parameters: {base_params}\n")
    print("Grid Search Combinations to be Tested:")

    print("\nThe Adam optimizer does not use a momentum parameter in the same way as SGD. It has its own internal momentum-like adaptive estimates called beta1 and beta2. So just one run with taking default momentum as 0.9 is enough for it.\n")
    # Generate all combinations from the search space
    keys, values = zip(*search_space.items())
    for combo in product(*values):
        run_params = dict(zip(keys, combo))
        
        # Identify invalid combinations (i.e. momentum for 'adam' optimizer)
        if run_params.get('optimizer') == 'adam' and 'momentum' in run_params:
            if run_params['momentum'] != base_params.get('momentum', 0.9):
                print(f"  RUN (Redundant: momentum for 'adam' optimizer):")
                for key, val in run_params.items():
                    print(f"    - {key}: {val}")
                continue
        
        print(f"  RUN:")
        for key, val in run_params.items():
            print(f"    - {key}: {val}")

if __name__ == "__main__":
    # Load all configurations first
    pipeline_cfg, params_cfg, grid_search_cfg = load_configs()
    
    # Run the simulation for questions a to d
    simulate_pipeline_run(pipeline_cfg, params_cfg)
    
    # Run the simulation for question e
    perform_hyperparameter_tuning(params_cfg, grid_search_cfg)

    print("Script finished successfully.")
    print("All outputs have been printed directly on the terminal.")