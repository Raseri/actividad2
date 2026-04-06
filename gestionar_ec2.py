import boto3
from botocore.exceptions import ClientError


ec2 = boto3.client('ec2', region_name='us-east-1')

def listar_instancias():
    print("--- Listando Instancias ---")
    try:
        response = ec2.describe_instances()
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                print(f"ID: {instance['InstanceId']}, Estado: {instance['State']['Name']}")
    except ClientError as e:
        print(f"Error al intentar listar las instancias: {e}")

def gestionar_instancia(instancia_id, accion):
    try:
        if accion == "iniciar":
            ec2.start_instances(InstanceIds=[instancia_id])
            print(f"Comando enviado para INICIAR la instancia: {instancia_id}")
        elif accion == "detener":
            ec2.stop_instances(InstanceIds=[instancia_id])
            print(f"Comando enviado para DETENER la instancia: {instancia_id}")
        else:
            print("Acción no válida. Usa 'iniciar' o 'detener'.")
    except ClientError as e:
        print(f"Error al gestionar la instancia {instancia_id}: {e}")

if __name__ == "__main__":
    listar_instancias()
    gestionar_instancia("i-036d7d28fe1c89d02", "detener")

